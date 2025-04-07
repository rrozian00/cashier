import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/widgets/my_appbar.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: Obx(() => Visibility(
              visible: controller.isOwner.value,
              child: IconButton(
                  onPressed: () => Get.toNamed(Routes.SETTINGS),
                  icon: Icon(
                    Icons.settings,
                    color: purple,
                  )),
            )),
        titleText: "Profil",
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.editProfile);
              },
              icon: Icon(
                Icons.edit_square,
                color: purple,
              ))
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => controller.isLoading.isFalse
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Nama dan Role
                    // Obx(() => Text(
                    //       controller.userData.value?.name ?? '',
                    //       style: GoogleFonts.poppins(
                    //           fontSize: 22, fontWeight: FontWeight.bold),
                    //     )),
                    // Obx(() => Text(
                    //       controller.userData.value?.role ?? '',
                    //       style: GoogleFonts.poppins(
                    //           fontSize: 18, color: Colors.grey),
                    //     )),

                    SizedBox(height: 20),

                    // Informasi Pengguna dalam Card
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildProfileItem(Icons.person, "Nama",
                                    controller.userData.value?.name ?? "-"),
                                Divider(),
                                _buildProfileItem(Icons.email, "Email",
                                    controller.userData.value?.email ?? "-"),
                                Divider(),
                                _buildProfileItem(Icons.location_on, "Alamat",
                                    controller.userData.value?.address ?? '-'),
                                Divider(),
                                _buildProfileItem(
                                    Icons.phone,
                                    "Telepon",
                                    controller.userData.value?.phoneNumber ??
                                        '-'),
                              ],
                            )),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Tombol Aksi
                    myPurpleElevated(
                      onPress: () => controller.changePassword(),
                      text: "Ubah Password",
                    ),
                    SizedBox(height: 20),

                    myRedElevated(
                      onPress: () => controller.showLogoutConfirm(),
                      text: "Keluar",
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ))),
    );
  }

  /// Widget untuk Item Profil
  Widget _buildProfileItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: purple),
      title:
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      subtitle: Text(value, key: ValueKey(value), style: GoogleFonts.poppins()),
    );
  }
}
