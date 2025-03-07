import 'dart:io';

import 'package:cashier/app/data/model/menu_model.dart';
import 'package:cashier/utils/my_elevated.dart';
import 'package:cashier/utils/rupiah_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MenuuController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  String storeId = ''; // Store ID dari store yang ditemukan
  var isOwner = false.obs; // Status apakah user adalah owner atau karyawan

  @override
  void onInit() {
    super.onInit();
    fetchStore();
    nameC.addListener(() {
      name.value = nameC.text;
    });
    priceC.addListener(() {
      price.value = priceC.text;
    });
  }

  var name = ''.obs;
  var price = ''.obs;
  var image = ''.obs;
  var isLoading = false.obs;

  final listMenu = <MenuModel>[].obs;
  final TextEditingController nameC = TextEditingController();
  final TextEditingController priceAddC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController imageC = TextEditingController();

  void resetC() {
    name.value = '';
    price.value = '';
    image.value = '';
    priceAddC.clear();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = pickedFile.path;
    }
  }

  /// 🔹 **Cek Store Berdasarkan Owner atau Karyawan**
  Future<void> fetchStore() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      isLoading.value = true;

      // Cek apakah user adalah owner store
      QuerySnapshot<Map<String, dynamic>> ownerStore = await _firestore
          .collection('stores')
          .where('ownerId', isEqualTo: userId)
          .get();

      if (ownerStore.docs.isNotEmpty) {
        storeId = ownerStore.docs.first.id;
        isOwner.value = true;
      } else {
        // Jika bukan owner, cek apakah user adalah karyawan
        QuerySnapshot<Map<String, dynamic>> employeeStore = await _firestore
            .collection('stores')
            .where('employees', arrayContains: userId)
            .get();

        if (employeeStore.docs.isNotEmpty) {
          storeId = employeeStore.docs.first.id;
          isOwner.value = false;
        }
      }

      if (storeId.isNotEmpty) {
        debugPrint("Store ditemukan: $storeId (Owner: ${isOwner.value})");
        fetchMenu();
      } else {
        Get.snackbar("Error", "Store tidak ditemukan untuk akun ini!");
      }
    } catch (e) {
      debugPrint("Error fetchStore: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengambil data store.");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 **Ambil Menu berdasarkan Store ID**
  void fetchMenu() {
    if (storeId.isEmpty) {
      debugPrint("fetchMenu() dibatalkan: storeId masih kosong");
      return;
    }

    _firestore
        .collection('stores/$storeId/menus')
        .snapshots()
        .listen((snapshot) {
      listMenu.assignAll(snapshot.docs.map((doc) {
        return MenuModel.fromJson(doc.data());
      }).toList());
    });
  }

  /// 🔹 **Tambah Menu (Hanya Owner)**
  Future<void> addMenu() async {
    if (!isOwner.value) {
      Get.snackbar(
          "Akses Ditolak", "Hanya pemilik toko yang bisa menambahkan menu.");
      return;
    }

    if (name.isEmpty || price.isEmpty) {
      Get.snackbar("Error", "Nama dan harga harus diisi!");
      return;
    }

    isLoading.value = true;
    final createdAt = DateTime.now().toIso8601String();
    final menu = MenuModel(
      name: name.value,
      price: price.value,
      image: image.value,
      createdAt: createdAt,
    );

    // Simpan ke subkoleksi menus di dalam Store
    DocumentReference docRef =
        await _firestore.collection('stores/$storeId/menus').add(menu.toJson());

    await docRef.update({"id": docRef.id});

    fetchMenu();
    isLoading.value = false;
  }

  /// 🔹 **Update Menu (Hanya Owner)**
  Future<void> updateMenu(MenuModel menu, String id) async {
    if (!isOwner.value) {
      Get.snackbar(
          "Akses Ditolak", "Hanya pemilik toko yang bisa mengedit menu.");
      return;
    }

    isLoading.value = true;
    await _firestore
        .collection('stores/$storeId/menus')
        .doc(id)
        .update(menu.toJson());
    fetchMenu();
    isLoading.value = false;
  }

  /// 🔹 **Hapus Menu (Hanya Owner)**
  Future<void> deleteMenu(String id) async {
    if (!isOwner.value) {
      Get.snackbar(
          "Akses Ditolak", "Hanya pemilik toko yang bisa menghapus menu.");
      return;
    }

    isLoading.value = true;
    await _firestore.collection('stores/$storeId/menus').doc(id).delete();
    fetchMenu();
    isLoading.value = false;
  }

  /// 🔹 **Dialog Tambah Menu**
  void addDialog() {
    if (!isOwner.value) {
      Get.snackbar(
          "Akses Ditolak", "Hanya pemilik toko yang bisa menambahkan menu.");
      return;
    }

    Get.defaultDialog(
      title: "Tambah Menu",
      cancel: ElevatedButton(
        onPressed: () {
          resetC();
          Get.back();
        },
        child: Text("Cancel"),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          addMenu();
          resetC();
          Get.back();
        },
        child: Text("Simpan"),
      ),
      content: Obx(() => Column(
            children: [
              image.value.isNotEmpty
                  ? Image.file(File(image.value), height: 100)
                  : Container(),
              myElevated(
                onPress: pickImage,
                child: Text('Pilih Gambar'),
              ),
              SizedBox(height: 8),
              TextField(
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.characters,
                onChanged: (value) => name.value = value,
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: priceAddC,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  String rawValue =
                      value.replaceAll('.', '').replaceAll('Rp ', '');
                  int parsedValue = int.tryParse(rawValue) ?? 0;
                  price.value = parsedValue.toString();
                  priceAddC.value = TextEditingValue(
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
            ],
          )),
    );
  }

  /// 🔹 **Dialog Konfirmasi Hapus Menu**
  void deleteDialog(String id) {
    Get.defaultDialog(
      title: "Hapus Menu",
      middleText: "Apakah Anda yakin ingin menghapus menu ini?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      onConfirm: () {
        deleteMenu(id);
        Get.back();
      },
    );
  }

  /// 🔹 **Dialog Edit Menu**
  // void editDialog(String id) {

  // final TextEditingController nameC = TextEditingController();
  // final TextEditingController priceC = TextEditingController();
  //   final menu = listMenu.firstWhereOrNull((m) => m.id == id);
  //   if (menu == null) return;

  //   nameC.text = menu.name!;
  //   priceC.text = menu.price!;
  //   image.value = menu.image ?? ''; // 🔹 Update nilai image.value

  //   Get.defaultDialog(
  //     title: "Edit Menu",
  //     content: Obx(() => Column(
  //           children: [
  //             image.value.isNotEmpty
  //                 ? Image.file(File(image.value), height: 100)
  //                 : Container(),
  //             myElevated(
  //               onPress: pickImage,
  //               child: Text('Pilih Gambar'),
  //             ),
  //             SizedBox(height: 8),
  //             TextField(
  //               controller: nameC,
  //               textInputAction: TextInputAction.next,
  //               textCapitalization: TextCapitalization.characters,
  //               decoration: InputDecoration(
  //                 labelText: "Nama",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 8),
  //             TextField(
  //               controller: priceC,
  //               keyboardType: TextInputType.number,
  //               onChanged: (value) {
  //                 String rawValue =
  //                     value.replaceAll('.', '').replaceAll('Rp ', '');
  //                 int parsedValue = int.tryParse(rawValue) ?? 0;
  //                 priceC.text = rupiahConverter(parsedValue);
  //                 priceC.selection =
  //                     TextSelection.collapsed(offset: priceC.text.length);
  //               },
  //               decoration: InputDecoration(
  //                 labelText: "Harga",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         )),
  //     confirm: myElevated(
  //       onPress: () {
  //         updateMenu(
  //             MenuModel(
  //               id: id,
  //               name: nameC.text, // 🔹 Ambil langsung dari controller
  //               price: priceC.text,
  //               image: image.value,
  //               createdAt: menu.createdAt,
  //             ),
  //             id);
  //         resetC();
  //         Get.back();
  //       },
  //       child: Text("Simpan"),
  //     ),
  //     cancel: myElevated(
  //       onPress: () {
  //         resetC();
  //         Get.back();
  //       },
  //       child: Text("Batal"),
  //     ),
  //   );
  // }
  void editDialog(String id) {
    final TextEditingController nameC = TextEditingController();
    final TextEditingController priceC = TextEditingController();

    final menu = listMenu.firstWhereOrNull((m) => m.id == id);
    if (menu == null) return;

    nameC.text = menu.name!;
    priceC.text = rupiahConverter(int.tryParse(menu.price ?? '0') ?? 0);
    image.value = menu.image ?? ''; // 🔹 Pastikan image diperbarui

    Get.defaultDialog(
      title: "Edit Menu",
      content: Column(
        children: [
          Obx(() => image.value.isNotEmpty
              ? Image.file(File(image.value), height: 100)
              : Container()),
          myElevated(
            onPress: pickImage,
            child: const Text('Pilih Gambar'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameC,
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
            controller: priceC,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // 🔹 Pastikan input tetap dalam format rupiah
              String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
              int parsedValue = int.tryParse(rawValue) ?? 0;
              priceC.value = TextEditingValue(
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
        ],
      ),
      confirm: myElevated(
        onPress: () {
          // 🔹 Pastikan keyboard tertutup sebelum menyimpan
          FocusScope.of(Get.context!).unfocus();

          updateMenu(
            MenuModel(
              id: id,
              name: nameC.text.trim(), // 🔹 Hindari spasi kosong di awal/akhir
              price: priceC.text
                  .replaceAll(RegExp(r'[^\d]'), ''), // 🔹 Simpan angka saja
              image: image.value,
              createdAt: menu.createdAt,
            ),
            id,
          );

          resetC();
          Get.back();
        },
        child: const Text("Simpan"),
      ),
      cancel: myElevated(
        onPress: () {
          resetC();
          Get.back();
        },
        child: const Text("Batal"),
      ),
    );
  }
}
