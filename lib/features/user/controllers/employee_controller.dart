import 'package:cashier/core/utils/get_store_id.dart';
import 'package:cashier/core/utils/get_user_data.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/features/user/models/user_model.dart';

class EmployeeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;

  final nameC = ''.obs;
  final emailC = ''.obs;
  final phoneC = ''.obs;
  final passwordC = ''.obs;
  final photoC = ''.obs;
  final salaryC = ''.obs;
  final addressC = ''.obs;

  Future<void> addEmployee() async {
    final String storeId = await getStoreId();

    if (nameC.value.isEmpty ||
        emailC.value.isEmpty ||
        phoneC.value.isEmpty ||
        salaryC.value.isEmpty ||
        passwordC.value.isEmpty) {
      Get.snackbar("Error", "Semua field harus diisi!");
      return;
    }

    try {
      Get.until(
        (route) => Get.currentRoute == Routes.employee,
      );
      isLoading.value = true;
      // Cek apakah user sudah terdaftar
      QuerySnapshot<Map<String, dynamic>> userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: emailC.value)
          .get();
      if (userQuery.docs.isNotEmpty) {
        Get.snackbar("Error", "Email sudah terdaftar sebagai karyawan!");
        isLoading.value = false;
        return;
      }

      if (storeId.isEmpty) {
        Get.snackbar("Error", "Store tidak ditemukan.");
        isLoading.value = false;
        return;
      }

      // **1. Buat akun Firebase Authentication untuk karyawan**
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailC.value,
        password: passwordC.value,
      );

      // Ambil ID karyawan dari Authentication
      String employeeId = userCredential.user!.uid;

      // **2. Simpan data karyawan ke Firestore**
      UserModel newEmployee = UserModel(
        id: employeeId,
        name: nameC.value,
        email: emailC.value,
        phoneNumber: phoneC.value,
        address: addressC.value,
        salary: salaryC.value,
        photo: photoC.value,
        role: "employee",
        createdAt: DateTime.now().toIso8601String(),
      );

      await _firestore
          .collection('users')
          .doc(employeeId)
          .set(newEmployee.toMap());

      // **3. Tambahkan ID karyawan ke Store**
      await _firestore.collection('stores').doc(storeId).update({
        "employees": FieldValue.arrayUnion([employeeId])
      });
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar("Sukses", "Karyawan ${nameC.value} berhasil ditambahkan!");
      clearForm();
      // Kembali ke halaman sebelumnya
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error: ${e.message}");
      Get.snackbar("Error", "Gagal membuat akun karyawan: ${e.message}");
    } on FirebaseException catch (e) {
      debugPrint("Firebase Error: ${e.message}");
      Get.snackbar("Error", "Gagal menambahkan karyawan: ${e.message}");
    } catch (e) {
      debugPrint("Error: $e");
      Get.snackbar("Error", "Terjadi kesalahan, coba lagi.");
    } finally {
      isLoading.value = false;
    }
  }

  final listEmployee = [].obs;

  void getEmployee() async {
    final storeId = await getStoreId();
    debugPrint("Get Employee dipanggil");
    final users = await getUserData();
    final userId = users?.id;
    debugPrint("UserID=$userId");
    debugPrint("store ID=$storeId");

    // Jika storeId tetap null, user tidak memiliki store
    if (storeId.isEmpty) {
      listEmployee.value = [];
      return;
    }

    final storeDoc = await _firestore.collection('stores').doc(storeId).get();
    final List<dynamic> employeeIdList =
        storeDoc.data()?['employees'] as List<dynamic>? ?? [];
    debugPrint("Employee=${employeeIdList.length}");
    if (employeeIdList.isEmpty) {
      listEmployee.value = [];
      return;
    }

    final employeeQuery = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: employeeIdList)
        .get();

    listEmployee.value = employeeQuery.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }

  void clearForm() {
    //   nameC.clear();
    //   emailC.clear();
    //   phoneC.clear();
    //   passwordC.clear();
    //   photoC.clear();
  }

  // @override
  // void onClose() {
  //   nameC.dispose();
  //   emailC.dispose();
  //   phoneC.dispose();
  //   passwordC.dispose();
  //   photoC.dispose();
  //   super.onClose();
  // }

  @override
  void onInit() {
    getEmployee();
    super.onInit();
  }
}
