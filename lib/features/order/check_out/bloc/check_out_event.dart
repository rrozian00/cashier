part of 'check_out_bloc.dart';

abstract class CheckOutEvent extends Equatable {
  const CheckOutEvent();

  @override
  List<Object> get props => [];
}

class InitCheckOut extends CheckOutEvent {
  final int totalHarga;
  const InitCheckOut(this.totalHarga);

  @override
  List<Object> get props => [totalHarga];
}

class NumberPressed extends CheckOutEvent {
  final String number;
  const NumberPressed(this.number);

  @override
  List<Object> get props => [number];
}

class ClearPressed extends CheckOutEvent {}

class ProcessPayment extends CheckOutEvent {
  final List<CartModel> cart;

  const ProcessPayment({required this.cart});
  @override
  List<Object> get props => [cart];
}

class ClearReceipt extends CheckOutEvent {}
