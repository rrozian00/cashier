// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'check_out_bloc.dart';

sealed class CheckOutState extends Equatable {
  // factory CheckOutState.initial() => const CheckOutState(
  //       processed: false,
  //       paymentAmount: 0,
  //       displayText: '',
  //       canProcess: false,
  //       cart: [],
  //       totalPrice: 0,
  //       isProcessing: false,
  //       user: null,
  //       store: null,
  //     );

  // CheckOutState copyWith({
  //   final List<CartModel>? cart,
  //   final int? paymentAmount,
  //   final int? totalPrice,
  //   final bool? isProcessing,
  //   final bool? processed,
  //   final String? displayText,
  //   final bool? canProcess,
  //   final String? errorMessage,
  //   final StoreModel? store,
  //   final UserModel? user,
  // }) {
  //   return CheckOutState(
  //       processed: processed ?? this.processed,
  //       cart: cart ?? this.cart,
  //       paymentAmount: paymentAmount ?? this.paymentAmount,
  //       totalPrice: totalPrice ?? this.totalPrice,
  //       isProcessing: isProcessing ?? this.isProcessing,
  //       displayText: displayText ?? this.displayText,
  //       canProcess: canProcess ?? this.canProcess,
  //       errorMessage: errorMessage ?? this.errorMessage,
  //       store: store ?? this.store,
  //       user: user ?? this.user);
  // }

  @override
  List<Object> get props => [
        // cart,
        // paymentAmount,
        // totalPrice,
        // isProcessing,
        // displayText,
        // canProcess,
        // processed,
      ];
}

final class CheckOutInitial extends CheckOutState {
  final List<CartModel> cart;
  final int paymentAmount;
  final int totalPrice;
  final bool isProcessing;
  final bool processed;
  final String displayText;
  final bool canProcess;
  final StoreModel? store;
  final UserModel? user;

  CheckOutInitial({
    required this.cart,
    required this.paymentAmount,
    required this.totalPrice,
    required this.isProcessing,
    required this.processed,
    required this.displayText,
    required this.canProcess,
    this.store,
    this.user,
  });

  CheckOutInitial copyWith({
    final List<CartModel>? cart,
    final int? paymentAmount,
    final int? totalPrice,
    final bool? isProcessing,
    final bool? processed,
    final String? displayText,
    final bool? canProcess,
    final String? errorMessage,
    final StoreModel? store,
    final UserModel? user,
  }) {
    return CheckOutInitial(
      cart: cart ?? this.cart,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      totalPrice: totalPrice ?? this.totalPrice,
      isProcessing: isProcessing ?? this.isProcessing,
      processed: processed ?? this.processed,
      displayText: displayText ?? this.displayText,
      canProcess: canProcess ?? this.canProcess,
      store: store ?? this.store,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [
        cart,
        paymentAmount,
        totalPrice,
        isProcessing,
        processed,
        displayText,
        canProcess,
      ];
}

final class CheckOutLoading extends CheckOutState {}

final class CheckOutError extends CheckOutState {
  final String errorMessage;
  CheckOutError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
