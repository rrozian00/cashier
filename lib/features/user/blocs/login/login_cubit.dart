import 'package:bloc/bloc.dart';

class LoginCubit extends Cubit<bool> {
  LoginCubit() : super(true);

  void changeObsecure() {
    emit(!state);
  }
}
