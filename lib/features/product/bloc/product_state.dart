part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductAddLoading extends ProductState {}

final class ProductEditLoading extends ProductState {}

final class ProductDeleteLoading extends ProductState {}

final class ProductPickLoading extends ProductState {}

final class ProductAddSuccess extends ProductState {}

final class ProductDeleteSuccess extends ProductState {}

final class ProductEditSuccess extends ProductState {}

final class PickImageSuccess extends ProductState {
  final String pickedImage;

  const PickImageSuccess(this.pickedImage);

  @override
  List<Object> get props => [pickedImage];
}

final class ProductSuccess extends ProductState {
  final List<ProductModel> products;

  const ProductSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

final class ProductFailed extends ProductState {
  final String message;

  const ProductFailed({required this.message});

  @override
  List<Object> get props => [message];
}
