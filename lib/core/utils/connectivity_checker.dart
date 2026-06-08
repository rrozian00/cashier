import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityChecker {
  static Future<bool> checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
      //supaya lanjut ke tahap selanjutnya
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      await Future.delayed(Duration(seconds: 1));
      return false;
    }
    return false;
  }
}
