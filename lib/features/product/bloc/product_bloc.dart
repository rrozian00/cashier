import 'package:bloc/bloc.dart';
import 'package:cashier/features/product/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProductGetRequested>((event, emit) async {
      emit(ProductLoading());
      // final result=await
    });
  }
}
