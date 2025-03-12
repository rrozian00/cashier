import 'package:cashier/app/routes/app_pages.dart';
import 'package:cashier/utils/my_appbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          titleText: 'Pengaturan',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.PROFILE);
                },
                title: "Profil Owner",
                icon: Icons.person,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.STORE);
                },
                title: " Profil Toko",
                icon: Icons.store,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.ADD_EMPLOYEE);
                },
                title: "Karyawan",
                icon: Icons.person_outline_rounded,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.MENU);
                },
                title: "Daftar Menu",
                icon: Icons.receipt_outlined,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.EXPENSE);
                },
                title: "Pengeluaran",
                icon: Icons.shopping_cart,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.INPUT_MANUAL);
                },
                title: "Input Manual",
                icon: Icons.checklist_rounded,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.HISTORY_ORDER);
                },
                title: "Riwayat",
                icon: Icons.history_toggle_off_rounded,
              ),
              Text("version: v.1, db.version: 1"),
            ],
          ),
        ));
  }
}

class _Listile extends StatelessWidget {
  final VoidCallback? onPress;
  final String? title;
  final IconData? icon;

  const _Listile({
    this.onPress,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15)),
        // color: Colors.black,
        child: ListTile(
          trailing: Icon(
            Icons.navigate_next_rounded,
            size: 40,
          ),
          onTap: onPress,
          contentPadding: EdgeInsets.all(6),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(icon),
          ),
          title: Text(
            title ?? "-",
            style: GoogleFonts.jetBrainsMono(color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }
}
