import 'package:bloc/bloc.dart';
import '../repositories/input_manual_repository.dart';
import 'package:equatable/equatable.dart';

part 'input_manual_event.dart';
part 'input_manual_state.dart';

class InputManualBloc extends Bloc<InputManualEvent, InputManualState> {
  final InputManualRepository inputManualRepo;

  InputManualBloc(this.inputManualRepo) : super(InputManualInitial()) {
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
