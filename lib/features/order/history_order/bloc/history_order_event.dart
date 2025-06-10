part of 'history_order_bloc.dart';

sealed class HistoryOrderEvent extends Equatable {
  const HistoryOrderEvent();

  @override
  List<Object> get props => [];
}

class ShowMyDateRange extends HistoryOrderEvent {
  final BuildContext context;
  const ShowMyDateRange({required this.context});

  @override
  List<Object> get props => [context];
}

class ShowInitial extends HistoryOrderEvent {
  final BuildContext context;
  const ShowInitial({required this.context});

  @override
  List<Object> get props => [context];
}
