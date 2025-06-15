import 'package:bloc/bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCubit extends Cubit<String> {
  VersionCubit() : super("");
  void showVersion() async {
    final info = await PackageInfo.fromPlatform();
    final version = info.version;
    final build = info.buildNumber;

    emit("Version: $version Build: $build");
  }
}
