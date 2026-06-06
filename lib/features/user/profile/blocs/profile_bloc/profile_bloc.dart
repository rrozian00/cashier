import 'package:bloc/bloc.dart';
import '../../../models/user_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  ProfileBloc(
    this.userRepository,
    this.authRepository,
  ) : super(ProfileInitial()) {
    on<ProfileFetched>(_onProfileFetched);
    on<LogoutSubmitted>(_onLogoutSubmitted);
  }

  Future<void> _onProfileFetched(
    ProfileFetched event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final user = await userRepository.getUserDataFromSupabase();
    user.fold(
      (l) => emit(ProfileError(message: l.toString())),
      (r) => emit(ProfileSuccess(r)),
    );
  }

  Future<void> _onLogoutSubmitted(
    LogoutSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    await authRepository.logout();
    emit(ProfileLogout());
  }
}
