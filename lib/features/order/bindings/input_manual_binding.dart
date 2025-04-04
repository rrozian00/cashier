import 'package:get/get.dart';

import '../controllers/input_manual_controller.dart';

class InputManualBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputManualController>(
      () => InputManualController(),
    );
  }
}
