import 'package:cashier/app/modules/home/controllers/home_controller.dart';
import 'package:cashier/app/modules/expense/controllers/expense_controller.dart';
import 'package:cashier/app/modules/history_order/controllers/history_order_controller.dart';
import 'package:cashier/app/modules/login/controllers/login_controller.dart';
import 'package:cashier/app/modules/menu/controllers/menuu_controller.dart';
import 'package:cashier/app/modules/order/controllers/order_controller.dart';
import 'package:cashier/app/modules/printer/controllers/printer_controller.dart';
import 'package:cashier/app/modules/profile/controllers/profile_controller.dart';
import 'package:cashier/app/modules/settings/controllers/settings_controller.dart';
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
    Get.lazyPut<MenuuController>(() => MenuuController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<PrinterController>(() => PrinterController());
  }
}
