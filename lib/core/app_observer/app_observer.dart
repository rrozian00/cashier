import 'package:bloc/bloc.dart';
import 'dart:developer';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log("bloc: $bloc -->  $change");
  }
}
