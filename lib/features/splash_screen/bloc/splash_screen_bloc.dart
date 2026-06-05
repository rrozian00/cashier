import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final _auth = Supabase.instance.client.auth;

  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<AuthenticationChecked>(_onAuthenticationChecked);
  }

  Future<void> _onAuthenticationChecked(
      AuthenticationChecked event, Emitter<SplashScreenState> emit) async {
    final session = _auth.currentSession;
    if (session != null) {
      emit(AuthenticationSuccess());
    } else {
      emit(AuthenticationError(message: "User not found"));
    }
  }
}
