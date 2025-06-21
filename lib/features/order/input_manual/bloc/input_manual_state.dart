part of 'input_manual_bloc.dart';

sealed class InputManualState extends Equatable {
  const InputManualState();

  @override
  List<Object> get props => [];
}

final class InputManualInitial extends InputManualState {}

final class InputManualLoading extends InputManualState {}

final class InputManualSuccess extends InputManualState {}

final class InputManualError extends InputManualState {
  final String message;

  const InputManualError({required this.message});

  @override
  List<Object> get props => [message];
}
