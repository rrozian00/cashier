import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final categoryList = ["Member", "Produk"];

  final categoryController = TextEditingController();
  final registeredDateController = TextEditingController();
  final expiredDateController = TextEditingController();
  final nameController = TextEditingController();
  final productCodeController = TextEditingController();
  final priceController = TextEditingController();

  final isLoading = false.obs;
  final isPickImageLoading = false.obs;

  final selectedImage = Rx<File?>(null);

  final selectedCategory = "".obs;

  DateTime registerDate = DateTime.now();
  DateTime expiredDate = DateTime.now();

  final picker = ImagePicker();

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

  void changeCategory(String value) {
    selectedCategory.value = value;
    categoryController.text = value;
  }

  Future<void> addProduct() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      await FirebaseFirestore.instance.collection("products").add({
        "category": categoryController.text,
        "name": nameController.text,
        "productCode": productCodeController.text,
        "price": int.parse(
          priceController.text.replaceAll(".", "").replaceAll("Rp ", ""),
        ),
        "registeredDate": registerDate,
        "expiredDate": expiredDate,
        "createdAt": Timestamp.now(),
      });

      Get.back();

      Get.snackbar(
        "Sukses",
        "Produk berhasil ditambahkan",
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
    categoryController.dispose();
    registeredDateController.dispose();
    expiredDateController.dispose();
    nameController.dispose();
    productCodeController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
