import 'package:cashier/core/theme/colors.dart';
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
                    Obx(() => Text(
                          controller.name.value.toUpperCase(),
                          style: GoogleFonts.poppins(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    Obx(() => Text(
                          controller.role.value,
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.grey),
                        )),

                    SizedBox(height: 20),

                    // Informasi Pengguna dalam Card
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildProfileItem(Icons.email, "Email",
                                    controller.user.value?.email ?? "-"),
                                Divider(),
                                _buildProfileItem(Icons.phone, "Telepon",
                                    controller.phone.value),
                                Divider(),
                                _buildProfileItem(Icons.location_on, "Alamat",
                                    controller.address.value),
                              ],
                            )),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Tombol Aksi
                    _buildActionButton(Icons.lock, "Ubah Password", purple,
                        () => controller.changePassword()),
                    SizedBox(height: 10),
                    _buildActionButton(Icons.logout, "Logout", red,
                        () => controller.showLogoutConfirm()),
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

  /// Widget untuk Tombol Aksi
  Widget _buildActionButton(
      IconData icon, String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold, color: white)),
        onPressed: onTap,
      ),
    );
  }
}
