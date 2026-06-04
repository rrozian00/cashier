import '../../home/controllers/home_controller.dart';
import '../controllers/navbar_controller.dart';
import '../../order/controllers/order_controler.dart';
import 'package:get/get.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(() => NavbarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
