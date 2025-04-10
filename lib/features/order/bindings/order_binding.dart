import 'package:cashier/features/menu/controllers/product_controller.dart';
import 'package:cashier/features/printer/controllers/printer_controller.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class TransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(
      () => OrderController(),
    );
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
    Get.lazyPut<PrinterController>(
      () => PrinterController(),
    );
  }
}
