import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/user/controllers/profile_controller.dart';

class ChangePassword extends GetView<ProfileController> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            homeIndocator(),
            Text(
              "Ubah Password",
              style: GoogleFonts.poppins(fontSize: 20, color: purple),
            ),
            SizedBox(height: 20),
            MyTextField(
              label: "Password Lama",
              controller: controller.oldPass,
              obscure: true,
            ),
            MyTextField(
              label: "Password Baru",
              controller: controller.newPass,
              obscure: true,
            ),
            MyTextField(
              label: "Ulangi Password Baru",
              controller: controller.reNewPass,
              obscure: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                myRedElevated(
                  width: 150,
                  text: "Batal",
                  onPress: () async {
                    Get.back();
                    controller.clearC();
                  },
                ),
                myGreenElevated(
                  width: 150,
                  text: "Simpan",
                  onPress: () async {
                    controller.showChangeDialog();
                  },
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
