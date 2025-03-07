import 'package:get/get.dart';

import '../controllers/menuu_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuuController>(
      () => MenuuController(),
    );
  }
}
