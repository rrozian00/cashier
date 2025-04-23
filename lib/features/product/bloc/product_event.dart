part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

final class ProductGetRequested extends ProductEvent {}

final class ProductAddRequested extends ProductEvent {}
