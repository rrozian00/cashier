import 'package:bloc/bloc.dart';
import '../../../core/app_version/app_version.dart';
import 'package:equatable/equatable.dart';

part 'version_state.dart';

class VersionCubit extends Cubit<List<String>> {
  VersionCubit() : super([]);
  void showVersion() async {
    final info = await AppVersion.getAppInfo();
    final version = info[0];
    final build = info[1];
    emit([version, build]);
  }
}
