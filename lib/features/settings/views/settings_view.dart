import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/features/user/controllers/profile_controller.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsView extends GetView<ProfileController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          titleText: 'Pengaturan',
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView(
            children: [
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.STORE);
                },
                title: "Toko",
                icon: Icons.store,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.employee);
                },
                title: "Karyawan",
                icon: Icons.person_outline_rounded,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.menus);
                },
                title: "Produk",
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
      padding: const EdgeInsets.only(
        top: 10,
        left: 10.0,
        right: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: grey),
            borderRadius: BorderRadius.circular(15)),
        // color: Colors.black,
        child: ListTile(
          trailing: Icon(
            color: grey,
            Icons.navigate_next_rounded,
            size: 35,
          ),
          onTap: onPress,
          contentPadding: EdgeInsets.all(6),
          leading: CircleAvatar(
            backgroundColor: grey.withAlpha(120),
            child: Icon(
              icon,
              color: purple,
            ),
          ),
          title: Text(
            title ?? "-",
            style: GoogleFonts.jetBrainsMono(color: brown),
          ),
        ),
      ),
    );
  }
}
