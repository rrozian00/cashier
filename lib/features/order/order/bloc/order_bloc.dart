// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';

// import '../../../../core/app_errors/failure.dart';
// import '../../../product/models/product_model.dart';
// import '../../../product/repositories/product_repository.dart';
// import '../repositories/order_repository.dart';

// part 'order_event.dart';
// part 'order_state.dart';

// class OrderBloc extends Bloc<OrderEvent, OrderState> {
//   final OrderRepository orderRepo;
//   final ProductRepository productRepo;
//   StreamSubscription<Either<Failure, List<ProductModel>>>? _productSubs;

//   final List<ProductModel> _cart = [];

//   OrderBloc(this.orderRepo, this.productRepo) : super(OrderInitial()) {
//     on<FetchProduct>(_onWatchProductRealtime);
//     on<StopWatchingProducts>(_onStopWatchingProducts);
//     on<_EmitError>((event, emit) {
//       emit(OrderError(message: event.message));
//     });
//     on<_EmitProductSuccess>((event, emit) {
//       emit(ProductLoaded(products: event.products));
//     });

//     // Cart logic
//     on<AddToCartByTap>(_onAddToCartByTap);
//     on<AddToCartByBarcode>(_onAddToCartByBarcode);
//     on<AddToCart>(_onAddToCart);
//     on<RemoveFromCart>(_onRemoveFromCart);
//     on<IncrementCartItem>(_onIncrementCartItem);
//     on<DecrementCartItem>(_onDecrementCartItem);
//     on<ClearCart>(_onClearCart);
//     on<UpdateCartItem>(_onUpdateCartItem);
//   }

//   List<ProductModel> get cart => _cart;

//   int get totalPrice => _cart.fold(0, (sum, item) {
//         final price = item.price ?? 0;
//         return sum + (price * (item.quantity ?? 0));
//       });

//   void _emitCart(Emitter<OrderState> emit) {
//     emit(OrderCartState(cart: List.from(_cart), totalPrice: totalPrice));
//   }

//   void _onAddToCart(AddToCart event, Emitter<OrderState> emit) {
//     final index = _cart.indexWhere((e) => e.id == event.product.id);

//     if (index == -1) {
//       // Buat product baru dengan quantity 1
//       _cart.add(ProductModel(quantity: 1));
//     } else {
//       // Update quantity di product yang ada

//       _cart[index] = ProductModel(quantity: index + 1);
//     }
//     _emitCart(emit);
//   }

//   void _onIncrementCartItem(IncrementCartItem event, Emitter<OrderState> emit) {
//     final index = _cart.indexWhere((e) => e.id == event.product.id);
//     if (index != -1) {
//       _cart[index] = ProductModel(quantity: index + 1);
//       _emitCart(emit);
//     }
//   }

//   void _onDecrementCartItem(DecrementCartItem event, Emitter<OrderState> emit) {
//     final index = _cart.indexWhere((e) => e.id == event.product.id);
//     if (index != -1) {
//       _cart[index] = ProductModel(quantity: index - 1);
//     } else {
//       _cart.removeAt(index);
//     }
//     _emitCart(emit);
//   }

//   void _onAddToCartByBarcode(
//       AddToCartByBarcode event, Emitter<OrderState> emit) async {
//     // final result = await productRepo.getProductByBarcode(event.barcodes);
//     // result.fold(
//     //   (err) => emit(OrderError(message: err.message)),
//     //   (product) => add(AddToCart(product: product)),
//     // );
//     emit(OrderLoading());
//     for (final barcode in event.barcodes) {
//       final result = await productRepo.getProductByBarcode(barcode);
//       result.fold(
//         (err) => emit(OrderError(message: err.message)),
//         (product) => add(AddToCart(product: product)),
//       );
//     }
//   }

//   Future<void> _onAddToCartByTap(
//       AddToCartByTap event, Emitter<OrderState> emit) async {
//     add(AddToCart(product: event.product));
//   }

//   void _onRemoveFromCart(RemoveFromCart event, Emitter<OrderState> emit) {
//     _cart.removeWhere((e) => e.id == event.product.id);
//     _emitCart(emit);
//   }

//   void _onClearCart(ClearCart event, Emitter<OrderState> emit) {
//     _cart.clear();
//     _emitCart(emit);
//   }

//   Future<void> _onWatchProductRealtime(
//     FetchProduct event,
//     Emitter<OrderState> emit,
//   ) async {
//     emit(OrderLoading());
//     await _productSubs?.cancel();
//     final sc = StreamController<OrderState>();

//     _productSubs = productRepo.watchProducts().listen(
//       (result) {
//         result.fold(
//           (err) => sc.add(OrderError(message: err.message)),
//           (data) => sc.add(
//             ProductLoaded(products: data),
//           ),
//         );
//       },
//     );
//     await emit.forEach<OrderState>(
//       sc.stream,
//       onData: (state) => state,
//     );
//   }

//   void _onStopWatchingProducts(
//     StopWatchingProducts event,
//     Emitter<OrderState> emit,
//   ) {
//     _productSubs?.cancel();
//   }

//   void _onUpdateCartItem(UpdateCartItem event, Emitter<OrderState> emit) {
//     final index = _cart.indexWhere((e) => e.id == event.product.id);
//     if (index != -1) {
//       if (event.quantity > 0) {
//         final updatedProduct = event.product.copyWith(quantity: event.quantity);
//         _cart[index] = updatedProduct;
//       } else {
//         _cart.removeAt(index);
//       }
//     } else {
//       if (event.quantity > 0) {
//         final newProduct = event.product.copyWith(quantity: event.quantity);
//         _cart.add(newProduct);
//       }
//     }
//     _emitCart(emit);
//   }
// }
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/app_errors/failure.dart';
import '../../../product/models/product_model.dart';
import '../../../product/repositories/product_repository.dart';
import '../repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepo;
  final ProductRepository productRepo;
  StreamSubscription<Either<Failure, List<ProductModel>>>? _productSubs;

  final List<ProductModel> _cart = [];

  OrderBloc(this.orderRepo, this.productRepo) : super(OrderInitial()) {
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

  List<ProductModel> get cart => _cart;

  int get totalPrice => _cart.fold(0, (sum, item) {
        final price = item.price ?? 0;
        return sum + (price * (item.quantity ?? 0));
      });

  void _emitCart(Emitter<OrderState> emit) {
    emit(OrderCartState(cart: List.from(_cart), totalPrice: totalPrice));
  }

  // 🔹 1. PERBAIKAN LOGIKA TAMBAH BARANG
  void _onAddToCart(AddToCart event, Emitter<OrderState> emit) {
    final index = _cart.indexWhere((e) => e.id == event.product.id);

    if (index == -1) {
      // Jika produk belum ada di keranjang, masukkan produk utuh dan set quantity = 1
      _cart.add(event.product.copyWith(quantity: 1));
    } else {
      // Jika sudah ada, ambil quantity lamanya lalu tambahkan 1 secara matematika
      final currentQty = _cart[index].quantity ?? 0;
      _cart[index] = _cart[index].copyWith(quantity: currentQty + 1);
    }
    _emitCart(emit);
  }

  // 🔹 2. PERBAIKAN LOGIKA TOMBOL (+)
  void _onIncrementCartItem(IncrementCartItem event, Emitter<OrderState> emit) {
    final index = _cart.indexWhere((e) => e.id == event.product.id);
    if (index != -1) {
      final currentQty = _cart[index].quantity ?? 0;
      _cart[index] = _cart[index].copyWith(quantity: currentQty + 1);
      _emitCart(emit);
    }
  }

  // 🔹 3. PERBAIKAN LOGIKA TOMBOL (-) AGAR TIDAK CRASH
  void _onDecrementCartItem(DecrementCartItem event, Emitter<OrderState> emit) {
    final index = _cart.indexWhere((e) => e.id == event.product.id);
    if (index != -1) {
      final currentQty = _cart[index].quantity ?? 0;
      if (currentQty > 1) {
        // Jika item masih banyak, kurangi 1
        _cart[index] = _cart[index].copyWith(quantity: currentQty - 1);
      } else {
        // Jika sisa 1 dipencet minus lagi, tendang dari keranjang
        _cart.removeAt(index);
      }
      _emitCart(emit);
    }
  }

  void _onAddToCartByBarcode(
      AddToCartByBarcode event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    for (final barcode in event.barcodes) {
      final result = await productRepo.getProductByBarcode(barcode);
      result.fold(
        (err) => emit(OrderError(message: err.message)),
        (product) => add(AddToCart(product: product)),
      );
    }
  }

  Future<void> _onAddToCartByTap(
      AddToCartByTap event, Emitter<OrderState> emit) async {
    add(AddToCart(product: event.product));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<OrderState> emit) {
    _cart.removeWhere((e) => e.id == event.product.id);
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
    final index = _cart.indexWhere((e) => e.id == event.product.id);
    if (index != -1) {
      if (event.quantity > 0) {
        _cart[index] = _cart[index].copyWith(quantity: event.quantity);
      } else {
        _cart.removeAt(index);
      }
    } else {
      if (event.quantity > 0) {
        _cart.add(event.product.copyWith(quantity: event.quantity));
      }
    }
    _emitCart(emit);
  }
}
