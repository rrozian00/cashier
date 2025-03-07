import 'package:cashier/app/modules/home/controllers/home_controller.dart';
import 'package:cashier/app/modules/menu/controllers/menuu_controller.dart';
import 'package:cashier/app/modules/printer/controllers/printer_controller.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class TransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(
      () => OrderController(),
    );
    Get.lazyPut<MenuuController>(
      () => MenuuController(),
    );
    Get.lazyPut<PrinterController>(
      () => PrinterController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
