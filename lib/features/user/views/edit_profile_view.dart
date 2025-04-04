import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/user/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleText: "Edit Profil",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Column(
          children: [
            MyTextField(
              controller: controller.name,
              label: "Nama",
            ),
            MyTextField(
              controller: controller.address,
              label: "Alamat",
            ),
            MyTextField(
              textInputType: TextInputType.number,
              controller: controller.phone,
              label: "No HP",
            ),
            myBlueElevated(
              text: "Simpan",
              onPress: () => controller.editProfile(),
            )
          ],
        ),
      ),
    );
  }
}
