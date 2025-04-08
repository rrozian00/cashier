import 'package:cashier/core/widgets/my_alert_dialog.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/user/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  controller.clearField();
                },
              ),
              myPurpleElevated(
                text: "Simpan",
                onPress: () {
                  Get.dialog(MyAlertDialog(
                      onConfirm: () async {
                        if (controller.userData.value == null) {
                          return;
                        }
                        debugPrint(
                            "userData.nama di editProfil:${controller.userData.value?.name}");

                        final idUser = controller.userData.value?.id;

                        try {
                          controller.isLoading.value = true;

                          Get.back();

                          final newData = controller.userData.value?.copyWith(
                            name: controller.name.value,
                            address: controller.address.value,
                            phoneNumber: controller.phone.value,
                          );

                          await controller.firestore
                              .collection("users")
                              .doc(idUser)
                              .update(newData!.toMap());

                          Get.snackbar("Sukses", "Profil berhasil diperbarui.");
                        } catch (e) {
                          Get.snackbar("Error", "Gagal memperbarui profil: $e");
                        } finally {
                          controller.isLoading.value = false;
                          controller.fetchUserProfile();
                        }
                      },
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
