part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

final class ProductGetRequested extends ProductEvent {}

final class ProductAddRequested extends ProductEvent {
  final String name;
  final String productCode;
  final String price;
  final String image;

  const ProductAddRequested({
    required this.name,
    required this.productCode,
    required this.price,
    required this.image,
  });

  @override
  List<Object> get props => [
        name,
        productCode,
        price,
        image,
        image,
      ];
}

final class ProductPickImageReq extends ProductEvent {}

final class ProductEditRequested extends ProductEvent {
  final String id;
  final String newName;
  final String newPrice;
  final String newImage;

  const ProductEditRequested(
      {required this.id,
      required this.newName,
      required this.newPrice,
      required this.newImage});

  @override
  List<Object> get props => [
        id,
        newName,
        newPrice,
        newImage,
      ];
}

final class ProductDeleteRequested extends ProductEvent {
  final String id;

  const ProductDeleteRequested(this.id);

  @override
  List<Object> get props => [id];
}
