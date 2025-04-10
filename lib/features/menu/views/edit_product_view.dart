import 'dart:io';

import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/menu/controllers/product_controller.dart';
import 'package:cashier/features/menu/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductView extends GetView<ProductController> {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments['data'] as ProductModel?;

    controller.produkIdC.text = data?.barcode ?? '';
    controller.nameC.text = data?.name ?? '';
    controller.priceC.text = data?.price ?? '';
    controller.image.value = data?.image ?? '';

    return Scaffold(
      appBar: MyAppBar(
        titleText: "Edit Produk",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => controller.image.value.isNotEmpty
                ? Image.file(File(controller.image.value), height: 100)
                : Container()),
            myElevated(
              onPress: controller.pickImage,
              child: const Text('Pilih Gambar'),
            ),
            SizedBox(height: 8),
            TextField(
              readOnly: true,
              keyboardType: TextInputType.number,
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
            const SizedBox(height: 8),
            TextField(
              controller: controller.nameC,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: "Nama",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.priceC,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // 🔹 Pastikan input tetap dalam format rupiah
                String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
                int parsedValue = int.tryParse(rawValue) ?? 0;
                controller.priceC.value = TextEditingValue(
                  text: rupiahConverter(parsedValue),
                  selection: TextSelection.collapsed(
                      offset: rupiahConverter(parsedValue).length),
                );
              },
              decoration: InputDecoration(
                labelText: "Harga",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 25),
            myPurpleElevated(
              width: 180,
              text: "Simpan",
              onPress: () => controller.editMenus(data!.id ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
