import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/user/views/change_password.dart';
import 'package:cashier/features/user/views/edit_profile_view.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGrey,
      appBar: MyAppBar(
        // leading: Obx(() => Visibility(
        //       visible: controller.isOwner.value,
        //       child: IconButton(
        //           onPressed: () => Get.toNamed(Routes.settings),
        //           icon: Icon(
        //             Icons.settings,
        //             color: blue,
        //           )),
        //     )),
        titleText: "Profil",
        actions: [
          TextButton(
              onPressed: () {
                Get.bottomSheet(
                    backgroundColor: white,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    EditProfileView());
              },
              child: Text(
                "Edit Profil",
                style: TextStyle(
                  color: blue,
                ),
              ))
        ],
      ),
      body: Obx(() => controller.isLoading.isFalse
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => SingleChildScrollView(
                    child: Column(
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
                        _buildProfileItem(Icons.phone, "Telepon",
                            controller.userData.value?.phoneNumber ?? '-'),
                        Divider(),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            myPurpleElevated(
                              width: 170,
                              onPress: () => Get.bottomSheet(
                                  backgroundColor: white,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                  ),
                                  ChangePassword()),
                              text: "Ubah Password",
                            ),
                            myRedElevated(
                              width: 170,
                              onPress: () => controller.showLogoutConfirm(),
                              text: "Keluar",
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            )
          : Center(
              child: CircularProgressIndicator(),
            )),
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
