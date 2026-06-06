import 'package:bloc/bloc.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserRepository _userRepository = UserRepository();
  EditProfileBloc() : super(EditProfileInitial()) {
    on<EditProfileSubmitted>((event, emit) async {
      emit(EditProfileLoading());
      final result = await _userRepository.editUser(
        user: event.user,
        newName: event.name,
        newAddress: event.address,
        newPhone: event.phone,
      );
      result.fold(
        (l) => emit(EditProfileError(message: l.toString())),
        (r) => emit(EditProfileSuccess()),
      );
    });
  }
}
