import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/routes/app_pages.dart';

import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: [
          TextButton(
              onPressed: () => controller.editDialog(context),
              child: Text(
                "Ubah Toko",
                style: TextStyle(
                  color: blue,
                ),
              ))
        ],
        titleText: "Profil Toko",
      ),
      body: Obx(() {
        if (controller.store.value == null) {
          return noData(
              icon: Icons.store,
              title: "Anda Belum Membuat Toko",
              message: "Silahkan Buat Toko Baru");
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/store.png",
                          color: purple,
                          width: 100,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    myList(
                        icon: Icons.store,
                        subtitle: controller.store.value?.name ?? '',
                        title: "Nama Toko"),
                    myList(
                        icon: Icons.location_on,
                        subtitle: controller.store.value?.address ?? '',
                        title: "Alamat Toko"),
                    myList(
                        icon: Icons.phone_android,
                        subtitle: controller.store.value?.phone ?? '',
                        title: "No HP Toko"),
                  ],
                ),
              ),
            ),
          );
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Obx(() => Visibility(
            visible: controller.store.value == null,
            child: myPurpleElevated(
                width: 180,
                height: 45,
                onPress: () => Get.toNamed(Routes.addStore),
                text: "Tambah Toko"),
          )),
    );
  }

  Widget myList({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          minTileHeight: 0,
          leading: Icon(
            icon,
            color: purple,
          ),
          subtitle: Text(
            subtitle,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(color: oldGrey, fontSize: 12),
          ),
        ),
        Divider()
      ],
    );
  }
}
