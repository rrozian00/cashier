import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../models/product_model.dart';

class EditProductController extends GetxController {
  final ProductModel product;

  EditProductController(this.product);

  late TextEditingController productCodeC;
  late TextEditingController nameC;
  late TextEditingController priceC;

  final isLoading = false.obs;
  final isPickImageLoading = false.obs;

  final selectedImage = Rx<File?>(null);

  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    productCodeC = TextEditingController(text: product.barcode ?? '');

    nameC = TextEditingController(text: product.name ?? '');

    priceC = TextEditingController(
      text: rupiahConverter(
        int.tryParse(product.price ?? '') ?? 0,
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      isPickImageLoading.value = true;

      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );

      if (picked != null) {
        selectedImage.value = File(picked.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memilih gambar",
      );
    } finally {
      isPickImageLoading.value = false;
    }
  }

  void formatPrice(String value) {
    final rawValue = value.replaceAll(RegExp(r'[^\d]'), '');

    final parsedValue = int.tryParse(rawValue) ?? 0;

    priceC.value = TextEditingValue(
      text: rupiahConverter(parsedValue),
      selection: TextSelection.collapsed(
        offset: rupiahConverter(parsedValue).length,
      ),
    );
  }

  Future<void> saveProduct() async {
    try {
      isLoading.value = true;

      await FirebaseFirestore.instance
          .collection("products")
          .doc(product.id)
          .update({
        "name": nameC.text,
        "price": priceC.text.replaceAll(".", "").replaceAll("Rp ", ""),
      });

      Get.back();

      Get.snackbar(
        "Sukses",
        "Produk berhasil diupdate",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    productCodeC.dispose();
    nameC.dispose();
    priceC.dispose();
    super.onClose();
  }
}
