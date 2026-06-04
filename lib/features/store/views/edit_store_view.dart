import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/my_text_field.dart';
import '../controllers/edit_store_controller.dart';

class EditStoreView extends GetView<EditStoreController> {
  const EditStoreView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // homeIndicator(),
            Text(
              "Ubah Toko",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            SizedBox(height: 15),
            MyTextField(controller: controller.nameC.value, label: "Nama Toko"),
            MyTextField(
                controller: controller.addressC.value, label: "Alamat Toko"),
            MyTextField(
                controller: controller.phoneC.value, label: "No HP Toko"),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Kembali"),
                ),
                ElevatedButton(
                  child: Text("Simpan"),
                  onPressed: () {
                    //
                  },
                ),
              ],
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
