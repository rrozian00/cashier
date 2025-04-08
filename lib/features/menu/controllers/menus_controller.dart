import 'package:cashier/core/utils/get_store_id.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cashier/core/utils/get_owner.dart';
import 'package:cashier/features/menu/models/product_model.dart';

class MenusController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  final storeId = ''.obs;
  final ownerTrue = true.obs;

  var name = ''.obs;
  // var scannedBarcode = ''.obs;
  var price = ''.obs;
  var image = ''.obs;
  var isLoading = false.obs;

  final listMenu = <ProductModel>[].obs;

  final TextEditingController produkIdC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController imageC = TextEditingController();

  void resetC() {
    produkIdC.clear();
    name.value = '';
    price.value = '';
    image.value = '';
    priceC.clear();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = pickedFile.path;
    }
  }

  /// 🔹 **Ambil Menu berdasarkan Store ID**
  void fetchMenu() async {
    storeId.value = await getStoreId();
    if (storeId.isNotEmpty || storeId.value != "") {
      debugPrint("ini storeId nyo:$storeId");
    } else {
      debugPrint("tak dapat store id nyo");
    }

    if (storeId.value == '') {
      debugPrint("fetchMenu() dibatalkan: storeId masih kosong");
      return;
    }

    _firestore
        .collection('stores/${storeId.value}/menus')
        .snapshots()
        .listen((snapshot) {
      listMenu.assignAll(snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data());
      }).toList());
    });
  }

  /// 🔹 **Tambah Menu (Hanya Owner)**
  Future<void> addMenu() async {
    if (!ownerTrue.value) {
      Get.snackbar(
          "Akses Ditolak", "Hanya pemilik toko yang bisa menambahkan menu.");
      return;
    }

    if (name.isEmpty || price.isEmpty) {
      Get.snackbar("Error", "Nama dan harga harus diisi!");
      return;
    }

    isLoading.value = true;

    final isExist = await _firestore
        .collection('stores/${storeId.value}/menus')
        .where("barcode", isEqualTo: produkIdC.text)
        .get();

    if (isExist.docs.isNotEmpty) {
      Get.snackbar("Gagal", "Produk sudah ada");
      return;
    }
    final docRef = _firestore.collection('stores/${storeId.value}/menus').doc();

    final createdAt = DateTime.now().toIso8601String();

    final data = ProductModel(
      id: docRef.id,
      barcode: produkIdC.text,
      name: name.value,
      price: priceC.text.replaceAll(RegExp(r'[^\d]'), ''),
      image: image.value,
      createdAt: createdAt,
    );
    await docRef.set(data.toMap());
    Get.back();
    resetC();
    fetchMenu();
    isLoading.value = false;
  }

  Future<void> editMenus(String id) async {
    if (!ownerTrue.value) {
      Get.snackbar(
          "Akses Ditolak", "Hanya pemilik toko yang bisa mengedit menu.");
      return;
    }

    isLoading.value = true;

    // 🔹 Ambil data lama dari Firestore
    final docSnapshot = await _firestore
        .collection('stores/${storeId.value}/menus')
        .doc(id)
        .get();

    if (!docSnapshot.exists) {
      Get.snackbar("Error", "Menu tidak ditemukan!");
      isLoading.value = false;
      return;
    }

    final oldData = ProductModel.fromMap(docSnapshot.data()!);

    // 🔹 Gunakan copyWith untuk update hanya field yang diubah
    final updatedData = oldData.copyWith(
      name: nameC.text.isNotEmpty ? nameC.text : null,
      price: priceC.text.replaceAll(RegExp(r'[^\d]'), '').isNotEmpty
          ? priceC.text.replaceAll(RegExp(r'[^\d]'), '')
          : null,
      image: image.value.isNotEmpty ? image.value : null,
    );

    // 🔹 Update ke Firestore
    await _firestore
        .collection('stores/${storeId.value}/menus')
        .doc(id)
        .update(updatedData.toMap());
    Get.until((route) => Get.currentRoute == Routes.menus);
    fetchMenu();
    isLoading.value = false;
  }

  //hapus
  Future<void> deleteMenu(String id) async {
    if (!ownerTrue.value) {
      Get.snackbar(
          "Akses Ditolak", "Hanya pemilik toko yang bisa menghapus menu.");
      return;
    }

    isLoading.value = true;
    await _firestore.collection('stores/$storeId/menus').doc(id).delete();
    fetchMenu();
    isLoading.value = false;
  }

  void getOwnerTrue() async {
    ownerTrue.value = await getOwner();
    if (ownerTrue.value == true) {
      debugPrint("ini owner");
    } else {
      debugPrint("ini karyawan");
    }
  }

  @override
  void onInit() {
    super.onInit();
    getOwnerTrue();
    fetchMenu();
    nameC.addListener(() {
      name.value = nameC.text;
    });
    priceC.addListener(() {
      price.value = priceC.text;
    });
  }
}
