import 'package:cashier/features/order/controllers/product_list_controller.dart';
import 'package:get/get.dart';

import 'package:cashier/features/menu/controllers/product_controller.dart';

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
    Get.lazyPut<ProductListController>(
      () => ProductListController(),
    );
  }
}
