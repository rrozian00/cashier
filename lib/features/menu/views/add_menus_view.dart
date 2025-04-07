import 'dart:io';

import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/core/utils/scanner_page.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/menu/controllers/menus_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMenusView extends GetView<MenusController> {
  const AddMenusView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.resetC();
    return Scaffold(
      appBar: MyAppBar(
        titleText: "Tambah Menu",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => Column(
              children: [
                controller.image.value.isNotEmpty
                    ? Image.file(File(controller.image.value), height: 100)
                    : Container(),
                myElevated(
                  onPress: controller.pickImage,
                  child: Text('Pilih Gambar'),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.produkIdC,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: "Kode Produk",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        String? hasilScan = await Get.to(ScannerPage());
                        if (hasilScan != null) {
                          controller.produkIdC.text = hasilScan;
                        }
                      },
                      icon: Icon(Icons.qr_code_scanner),
                    )
                  ],
                ),
                SizedBox(height: 8),
                TextField(
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) => controller.name.value = value,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: controller.priceC,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    String rawValue =
                        value.replaceAll('.', '').replaceAll('Rp ', '');
                    int parsedValue = int.tryParse(rawValue) ?? 0;
                    controller.price.value = parsedValue.toString();
                    controller.priceC.value = TextEditingValue(
                      text: rupiahConverter(parsedValue),
                      selection: TextSelection.collapsed(
                          offset: rupiahConverter(parsedValue).length),
                    );
                  },
                  decoration: InputDecoration(
                    labelText: "Harga",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                myPurpleElevated(
                    text: "Simpan", onPress: () => controller.addMenu()),
              ],
            )),
      ),
    );
  }
}
