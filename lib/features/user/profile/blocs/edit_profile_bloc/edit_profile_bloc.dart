import 'package:bloc/bloc.dart';
import 'package:cashier/features/user/models/user_model.dart';
import '../../../repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserRepository _userRepository = UserRepository();
  EditProfileBloc() : super(EditProfileInitial()) {
    on<EditProfileSubmitted>((event, emit) async {
      emit(EditProfileLoading());
      await _userRepository.editUser(
        user: event.user,
        newName: event.name,
        newAddress: event.address,
        newPhone: event.phone,
      );
      emit(EditProfileSuccess());
    });
  }
}
