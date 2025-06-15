part of 'history_order_bloc.dart';

sealed class HistoryOrderEvent extends Equatable {
  const HistoryOrderEvent();

  @override
  List<Object> get props => [];
}

class ShowMyDateRange extends HistoryOrderEvent {
  final DateTimeRange picked;

  const ShowMyDateRange({required this.picked});
  @override
  List<Object> get props => [picked];
}

class ShowInitial extends HistoryOrderEvent {
  final BuildContext context;

  const ShowInitial({required this.context});

  @override
  List<Object> get props => [context];
}
