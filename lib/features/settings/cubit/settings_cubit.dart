import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<String> {
  SettingsCubit() : super("Loading...") {
    loadAppVersion();
  }

  Future<void> loadAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      emit('Version: ${packageInfo.version}+${packageInfo.buildNumber}');
    } catch (e) {
      emit("Version Unavailable");
    }
  }
}
