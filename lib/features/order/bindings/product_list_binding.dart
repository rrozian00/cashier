import 'package:cashier/features/order/controllers/product_list_controller.dart';
import 'package:get/get.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(
      () => ProductListController(),
    );
  }
}
