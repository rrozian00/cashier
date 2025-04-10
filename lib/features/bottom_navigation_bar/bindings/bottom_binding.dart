import 'package:cashier/features/home/controllers/home_controller.dart';
import 'package:cashier/features/expense/controllers/expense_controller.dart';
import 'package:cashier/features/order/controllers/history_order_controller.dart';
import 'package:cashier/features/login/controllers/login_controller.dart';
import 'package:cashier/features/menu/controllers/product_controller.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:cashier/features/printer/controllers/printer_controller.dart';
import 'package:cashier/features/user/controllers/profile_controller.dart';
import 'package:cashier/features/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

import '../controllers/bottom_controller.dart';

class BottomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomController>(() => BottomController());
    Get.lazyPut<ExpenseController>(() => ExpenseController());
    Get.lazyPut<OrderController>(() => OrderController());
    Get.lazyPut<HistoryOrderController>(() => HistoryOrderController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<PrinterController>(() => PrinterController());
  }
}
