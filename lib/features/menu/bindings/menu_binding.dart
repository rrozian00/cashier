import 'package:get/get.dart';

import '../controllers/menus_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenusController>(
      () => MenusController(),
    );
  }
}
