import 'package:cashier/features/order/controllers/history_order_controller.dart';
import 'package:cashier/features/printer/controllers/printer_controller.dart';

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
    Get.lazyPut<PrinterController>(() => PrinterController(), fenix: true);
  }
}
