import 'package:cashier/features/user/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../controllers/employee_controller.dart';

class AddEmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeController>(
      () => EmployeeController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
