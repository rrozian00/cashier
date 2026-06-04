import 'package:bloc/bloc.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cashier/features/user/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc(this.userRepository) : super(ProfileInitial()) {
    on<GetProfile>(_onProfileEvent);
  }

  Future<void> _onProfileEvent(
    GetProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileInitial());
    emit(ProfileLoaded(event.user));
  }
}
