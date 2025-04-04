import 'package:get/get.dart';

import '../controllers/expense_controller.dart';

class PengeluaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseController>(
      () => ExpenseController(),
    );
  }
}
