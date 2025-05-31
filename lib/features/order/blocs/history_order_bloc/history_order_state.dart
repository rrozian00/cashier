part of 'history_order_bloc.dart';

sealed class HistoryOrderState extends Equatable {
  const HistoryOrderState();

  @override
  List<Object> get props => [];
}

final class HistoryOrderLoading extends HistoryOrderState {}

final class HistoryOrderLoaded extends HistoryOrderState {
  final List<OrderModel> orders;
  final DateTimeRange? picked;

  const HistoryOrderLoaded({
    required this.orders,
    this.picked,
  });

  @override
  List<Object> get props => [orders, picked ?? ''];
}

final class HistoryOrderFailed extends HistoryOrderState {
  final String message;

  const HistoryOrderFailed({required this.message});

  @override
  List<Object> get props => [message];
}
