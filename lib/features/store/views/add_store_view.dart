import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/my_appbar.dart';

import '../../../core/widgets/my_text_field.dart';
import '../controllers/store_controller.dart';

class AddStoreView extends GetView<StoreController> {
  const AddStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titleText: "Tambah Toko"),
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
                        // text: "Simpan",
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
