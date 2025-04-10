import 'package:cashier/features/user/controllers/employee_controller.dart';
import 'package:get/get.dart';

import '../controllers/history_order_controller.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryOrderController>(
      () => HistoryOrderController(),
    );
    Get.lazyPut<EmployeeController>(
      () => EmployeeController(),
    );
  }
}
