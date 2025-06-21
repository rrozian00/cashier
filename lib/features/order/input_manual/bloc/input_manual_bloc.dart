import 'package:bloc/bloc.dart';
import 'package:cashier/features/order/input_manual/repositories/input_manual_repository.dart';
import 'package:equatable/equatable.dart';

part 'input_manual_event.dart';
part 'input_manual_state.dart';

class InputManualBloc extends Bloc<InputManualEvent, InputManualState> {
  final inputManualRepo = InputManualRepository();

  InputManualBloc() : super(InputManualInitial()) {
    on<AddInputManual>((event, emit) async {
      try {
        emit(InputManualLoading());
        await inputManualRepo.inputManual(event.total, event.date);
        emit(InputManualSuccess());
      } catch (e) {
        emit(InputManualError(message: e.toString()));
      }
    });
  }
}
