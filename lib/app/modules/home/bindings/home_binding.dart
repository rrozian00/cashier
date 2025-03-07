import 'package:cashier/app/modules/history_order/controllers/history_order_controller.dart';
import 'package:cashier/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<HistoryOrderController>(
      () => HistoryOrderController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
