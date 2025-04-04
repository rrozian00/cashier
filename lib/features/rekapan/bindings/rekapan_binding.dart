import 'package:get/get.dart';

import '../controllers/rekapan_controller.dart';

class RekapanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekapanController>(
      () => RekapanController(),
    );
  }
}
