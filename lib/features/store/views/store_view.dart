import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: [
          IconButton(
              onPressed: () => controller.editDialog(),
              icon: Icon(
                Icons.edit,
                color: blue,
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
      floatingActionButton: Obx(() => Visibility(
            visible: controller.store.value == null,
            child: ElevatedButton(
                onPressed: () => Get.to(() => AddStoreView()),
                child: Text("Tambah Toko")),
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
            style: GoogleFonts.poppins(color: red, fontSize: 12),
          ),
        ),
        Divider()
      ],
    );
  }
}

class AddStoreView extends GetView<StoreController> {
  const AddStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Toko")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Toko
            MyTextField(
              label: "Nama Toko",
              controller: controller.name,
            ),

            SizedBox(height: 10),

            // Alamat
            MyTextField(controller: controller.address, label: "Alamat"),

            SizedBox(height: 10),

            // Nomor HP
            MyTextField(
              label: "No HP",
              controller: controller.phone,
              textInputType: TextInputType.phone,
            ),

            SizedBox(height: 10),

            // Logo URL
            MyTextField(
              label: "Logo",
              controller: controller.logoUrl,
            ),

            SizedBox(height: 20),

            // Tombol Simpan
            Obx(() {
              return controller.isLoading.value
                  ? Center(child: CircularProgressIndicator()) // Loading
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.addStore();
                        },
                        child: Text("Simpan"),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
