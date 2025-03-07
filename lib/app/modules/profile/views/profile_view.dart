import 'dart:io';

import 'package:cashier/utils/my_appbar.dart';
import 'package:cashier/utils/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
                Get.to(() => EditProfile());
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Profil
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: Obx(
                        () => Image.file(
                          File(controller.photo.value),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Tombol Edit Foto
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                        onPressed: () {
                          controller.pickImage();
                        },
                        icon: Icon(Icons.camera_alt,
                            color: Colors.white, size: 20)),
                  ),
                ],
              ),
            ),

            // Nama dan Role
            Obx(() => Text(
                  controller.name.value.toUpperCase(),
                  style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.bold),
                )),
            Obx(() => Text(
                  controller.role.value,
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
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
                        _buildProfileItem(
                            Icons.phone, "Telepon", controller.phone.value),
                        Divider(),
                        _buildProfileItem(Icons.location_on, "Alamat",
                            controller.address.value),
                      ],
                    )),
              ),
            ),

            SizedBox(height: 20),

            // Tombol Aksi
            _buildActionButton(Icons.lock, "Ubah Password", Colors.blue,
                () => controller.changePassword()),
            SizedBox(height: 10),
            _buildActionButton(Icons.logout, "Logout", Colors.red,
                () => controller.showLogoutConfirm()),
          ],
        ),
      ),
    );
  }

  /// Widget untuk Item Profil
  Widget _buildProfileItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
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
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
        onPressed: onTap,
      ),
    );
  }
}

class EditProfile extends GetView<ProfileController> {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleText: "Edit Profil",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: ListView(
          children: [
            myTextField(
              hint: "Nama",
            ),
            myTextField(
              hint: "Alamat",
            ),
            myTextField(
              hint: "ImageUrl",
            ),
          ],
        ),
      ),
    );
  }
}
