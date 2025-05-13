import 'package:bloc/bloc.dart';
import 'package:cashier/features/order/repositories/order_repository.dart';
import 'package:cashier/features/product/models/product_model.dart';
import 'package:cashier/features/product/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final orderRepo = OrderRepository();
  final productRepo = ProductRepository();
  OrderBloc() : super(OrderInitial()) {
    on<Fetchroduct>(_onFetchProduct);
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onFetchProduct(
    Fetchroduct event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await productRepo.getProducts();
    result.fold(
      (err) {
        emit(OrderError(message: err.message));
      },
      (data) {
        emit(OrderLoaded(products: data));
      },
    );
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<OrderState> emit,
  ) async {
    if (state is! OrderLoaded) return;

    final currentState = state as OrderLoaded;
    final cart = List<Map<String, dynamic>>.from(currentState.cart);
    bool productExist = cart.any(
      (element) => element['produk'] == event.product,
    );

    if (productExist) {
      for (var el in cart) {
        if (el['produk'] == event.product) {
          el['jumlah']++;
        }
      }
    } else {
      cart.add({'produk': event.product, 'jumlah': 1});
    }
    final total = _calculateTotal(cart);
    emit(currentState.copyWith(
        cart: cart,
        totalHarga: total,
        kembalian: currentState.jumlahBayar >= total
            ? currentState.jumlahBayar - total
            : 0));
  }

//fungsi hitung total
  int _calculateTotal(List<Map<String, dynamic>> cart) {
    int total = 0;
    for (var item in cart) {
      final produk = item['produk'] as ProductModel;
      final jumlah = item['jumlah'] as int;
      total += (int.tryParse(produk.price ?? '0') ?? 0) * jumlah;
    }
    return total;
  }
}
