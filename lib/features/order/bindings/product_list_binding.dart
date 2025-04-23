import 'package:cashier/features/product/controllers/product_list_controller.dart';
import 'package:get/get.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(
      () => ProductListController(),
    );
  }
}
