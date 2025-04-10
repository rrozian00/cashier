import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:cashier/core/widgets/my_alert_dialog.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/user/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.name.value = controller.userData.value?.name ?? '';
    controller.address.value = controller.userData.value?.address ?? '';
    controller.phone.value = controller.userData.value?.phoneNumber ?? '';

    debugPrint("isi name.value=${controller.name.value}");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          homeIndocator(),
          Text(
            "Ubah Profil",
            style: GoogleFonts.poppins(color: purple, fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
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
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myRedElevated(
                text: "Batal",
                onPress: () {
                  Get.back();
                },
              ),
              myGreenElevated(
                text: "Simpan",
                onPress: () {
                  Get.dialog(MyAlertDialog(
                      onConfirm: () async => controller.showEditProfile(),
                      contentText: "Anda yakin akan menyimpan data?"));
                },
              ),
            ],
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
