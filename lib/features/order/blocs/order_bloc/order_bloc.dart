import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../models/cart_model.dart';
import '../../../../core/errors/failure.dart';
import '../../repositories/order_repository.dart';
import '../../../product/models/product_model.dart';
import '../../../product/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final orderRepo = OrderRepository();
  final productRepo = ProductRepository();
  StreamSubscription<Either<Failure, List<ProductModel>>>? _productSubs;

  final List<CartModel> _cart = [];

  OrderBloc() : super(OrderInitial()) {
    on<FetchProduct>(_onWatchProductRealtime);
    on<StopWatchingProducts>(_onStopWatchingProducts);
    on<_EmitError>((event, emit) {
      emit(OrderError(message: event.message));
    });
    on<_EmitProductSuccess>((event, emit) {
      emit(ProductLoaded(products: event.products));
    });

    // Cart logic
    on<AddToCartByTap>(_onAddToCartByTap);
    on<AddToCartByBarcode>(_onAddToCartByBarcode);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncrementCartItem>(_onIncrementCartItem);
    on<DecrementCartItem>(_onDecrementCartItem);
    on<ClearCart>(_onClearCart);
    on<UpdateCartItem>(_onUpdateCartItem);
  }

  List<CartModel> get cart => _cart;

  int get totalPrice => _cart.fold(0, (sum, item) {
        final price = int.tryParse(item.product.price ?? '0') ?? 0;
        return sum + (price * item.quantity);
      });

  void _emitCart(Emitter<OrderState> emit) {
    emit(OrderCartState(cart: List.from(_cart), totalPrice: totalPrice));
  }

  void _onAddToCart(AddToCart event, Emitter<OrderState> emit) {
    final index = _cart.indexWhere((e) => e.product.id == event.product.id);
    if (index == -1) {
      _cart.add(CartModel(product: event.product, quantity: 1));
    } else {
      final current = _cart[index];
      _cart[index] = current.copyWith(quantity: current.quantity + 1);
    }
    _emitCart(emit);
  }

  void _onIncrementCartItem(IncrementCartItem event, Emitter<OrderState> emit) {
    final index = _cart.indexWhere((e) => e.product.id == event.product.id);
    if (index != -1) {
      final current = _cart[index];
      _cart[index] = current.copyWith(quantity: current.quantity + 1);
    }
    _emitCart(emit);
  }

  void _onDecrementCartItem(DecrementCartItem event, Emitter<OrderState> emit) {
    final index = _cart.indexWhere((e) => e.product.id == event.product.id);
    if (index != -1) {
      final current = _cart[index];
      if (current.quantity > 1) {
        _cart[index] = current.copyWith(quantity: current.quantity - 1);
      } else {
        _cart.removeAt(index);
      }
    }
    _emitCart(emit);
  }

  void _onAddToCartByBarcode(
      AddToCartByBarcode event, Emitter<OrderState> emit) async {
    final result = await productRepo.getProductByBarcode(event.barcode);
    result.fold(
      (err) => emit(OrderError(message: err.message)),
      (product) => add(AddToCart(product: product)),
    );
  }

  Future<void> _onAddToCartByTap(
      AddToCartByTap event, Emitter<OrderState> emit) async {
    add(AddToCart(product: event.product));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<OrderState> emit) {
    _cart.removeWhere((e) => e.product.id == event.product.id);
    _emitCart(emit);
  }

  void _onClearCart(ClearCart event, Emitter<OrderState> emit) {
    _cart.clear();
    _emitCart(emit);
  }

  Future<void> _onWatchProductRealtime(
    FetchProduct event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    await _productSubs?.cancel();
    final sc = StreamController<OrderState>();

    _productSubs = productRepo.watchProducts().listen(
      (result) {
        result.fold(
          (err) => sc.add(OrderError(message: err.message)),
          (data) => sc.add(
            ProductLoaded(products: data),
          ),
        );
      },
    );
    await emit.forEach<OrderState>(
      sc.stream,
      onData: (state) => state,
    );
  }

  void _onStopWatchingProducts(
    StopWatchingProducts event,
    Emitter<OrderState> emit,
  ) {
    _productSubs?.cancel();
  }

  void _onUpdateCartItem(UpdateCartItem event, Emitter<OrderState> emit) {
    final index = _cart.indexWhere((e) => e.product.id == event.product.id);
    if (index != -1) {
      if (event.quantity > 0) {
        _cart[index] = _cart[index].copyWith(quantity: event.quantity);
      } else {
        _cart.removeAt(index);
      }
    } else {
      if (event.quantity > 0) {
        _cart.add(CartModel(product: event.product, quantity: event.quantity));
      }
    }
    _emitCart(emit);
  }
}
