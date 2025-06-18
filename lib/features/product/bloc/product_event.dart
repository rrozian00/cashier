part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

final class ProductGetRequested extends ProductEvent {}

final class ProductAddRequested extends ProductEvent {
  final String name;
  final String category;
  final String productCode;
  final DateTime registeredDate;
  final DateTime expiredDate;
  final String price;
  // final File image;

  const ProductAddRequested({
    required this.registeredDate,
    required this.expiredDate,
    required this.name,
    required this.category,
    required this.productCode,
    required this.price,
    // required this.image,
  });

  @override
  List<Object> get props => [
        registeredDate,
        expiredDate,
        category,
        name,
        productCode,
        price,
      ];
}

final class ProductPickImageReq extends ProductEvent {}

final class ProductEditRequested extends ProductEvent {
  final String id;
  final String newName;
  final String newPrice;
  final String publicId;
  // final File newImage;

  const ProductEditRequested({
    required this.id,
    required this.newName,
    required this.newPrice,
    required this.publicId,
    // required this.newImage,
  });

  @override
  List<Object> get props => [
        // newImage,
        publicId,
        id,
        newName,
        newPrice,
      ];
}

final class ProductDeleteRequested extends ProductEvent {
  final String id;

  const ProductDeleteRequested(this.id);

  @override
  List<Object> get props => [id];
}

class ProductCategoryChanged extends ProductEvent {
  final String category;
  const ProductCategoryChanged({required this.category});
}
