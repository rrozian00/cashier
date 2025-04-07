import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/core/utils/get_user_data.dart';

class BottomController extends GetxController {
  var selectedIndex = 0.obs;

  final role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserRole();
  }

  void getUserRole() async {
    final userData = await getUserData();

    if (userData != null) {
      role.value = userData.role ?? '';
      debugPrint("User Role:$role");
    } else {
      Get.snackbar("Error", "Akun tidak ditemukan!");
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
