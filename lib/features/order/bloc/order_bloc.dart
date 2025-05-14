import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../core/errors/failure.dart';
import '../repositories/order_repository.dart';
import '../../product/models/product_model.dart';
import '../../product/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final orderRepo = OrderRepository();
  final productRepo = ProductRepository();
  StreamSubscription<Either<Failure, List<ProductModel>>>? _productSubs;

  OrderBloc() : super(OrderInitial()) {
    on<Fetchroduct>(_onWatchProductRealtime);
    on<StopWatchingProducts>(_onStopWatchingProducts);
    on<_EmitError>((event, emit) {
      emit(OrderError(message: event.message));
    });
    on<_EmitProductSuccess>((event, emit) {
      emit(ProductSuccess(products: event.products));
    });
  }

  Future<void> _onWatchProductRealtime(
    Fetchroduct event,
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
            ProductSuccess(products: data),
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
}
