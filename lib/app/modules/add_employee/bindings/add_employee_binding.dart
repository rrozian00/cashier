import 'package:cashier/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEmployeeController>(
      () => AddEmployeeController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
