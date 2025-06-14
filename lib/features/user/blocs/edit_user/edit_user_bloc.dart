import 'package:bloc/bloc.dart';
import 'package:cashier/features/user/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  final UserRepository _userRepository = UserRepository();
  EditUserBloc() : super(EditUserInitial()) {
    on<EditRequestedEvent>((event, emit) async {
      emit(EditUserLoading());
      await _userRepository.editUser(
        id: event.id,
        newName: event.name,
        newAddress: event.address,
        newPhone: event.phone,
      );
      emit(EditUserSuccess());
    });
  }
}
