part of 'input_manual_bloc.dart';

sealed class InputManualEvent extends Equatable {
  const InputManualEvent();

  @override
  List<Object> get props => [];
}

final class AddInputManual extends InputManualEvent {
  final String total;
  final DateTime date;

  const AddInputManual({required this.total, required this.date});

  @override
  List<Object> get props => [total, date];
}
