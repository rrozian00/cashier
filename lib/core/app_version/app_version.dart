import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  static Future<List<String>> getAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    final version = info.version;
    final build = info.buildNumber;
    return [version, build];
  }
}
