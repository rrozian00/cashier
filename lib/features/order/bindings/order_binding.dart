import 'package:cashier/features/home/controllers/home_controller.dart';
import 'package:cashier/features/menu/controllers/menus_controller.dart';
import 'package:cashier/features/printer/controllers/printer_controller.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class TransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(
      () => OrderController(),
    );
    Get.lazyPut<MenusController>(
      () => MenusController(),
    );
    Get.lazyPut<PrinterController>(
      () => PrinterController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
