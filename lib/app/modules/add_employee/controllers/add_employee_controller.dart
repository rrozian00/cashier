import 'package:cashier/app/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEmployeeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;

  @override
  void onInit() {
    getEmployee();
    super.onInit();
  }

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController photoC = TextEditingController();
  final TextEditingController salaryC = TextEditingController();
  final TextEditingController addressC = TextEditingController();

  String storeId = ""; // Akan diambil dari Firestore

  Future<void> addEmployee() async {
    if (nameC.text.isEmpty ||
        emailC.text.isEmpty ||
        phoneC.text.isEmpty ||
        salaryC.text.isEmpty ||
        passwordC.text.isEmpty) {
      Get.snackbar("Error", "Semua field harus diisi!");
      return;
    }

    try {
      isLoading.value = true;

      // Cek apakah user sudah terdaftar
      QuerySnapshot<Map<String, dynamic>> userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: emailC.text)
          .get();

      if (userQuery.docs.isNotEmpty) {
        Get.snackbar("Error", "Email sudah terdaftar sebagai karyawan!");
        isLoading.value = false;
        return;
      }

      // Ambil ID owner yang sedang login
      String? ownerId = _auth.currentUser?.uid;

      // Cari store yang dimiliki owner atau tempat dia bekerja
      QuerySnapshot<Map<String, dynamic>> storeQuery = await _firestore
          .collection('stores')
          .where(Filter.or(
            Filter("ownerId", isEqualTo: ownerId),
            Filter("employees", arrayContains: ownerId),
          ))
          .get();

      if (storeQuery.docs.isEmpty) {
        Get.snackbar("Error", "Store tidak ditemukan.");
        isLoading.value = false;
        return;
      }

      // Ambil ID store pertama yang ditemukan
      storeId = storeQuery.docs.first.id;
      print("Store ID: $storeId");

      // **1. Buat akun Firebase Authentication untuk karyawan**
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailC.text,
        password: passwordC.text,
      );

      // Ambil ID karyawan dari Authentication
      String employeeId = userCredential.user!.uid;

      // **2. Simpan data karyawan ke Firestore**
      UserModel newEmployee = UserModel(
        id: employeeId,
        name: nameC.text,
        email: emailC.text,
        phoneNumber: phoneC.text,
        address: addressC.text,
        salary: salaryC.text,
        photo: photoC.text,
        role: "karyawan",
        createdAt: DateTime.now().toIso8601String(),
      );

      await _firestore
          .collection('users')
          .doc(employeeId)
          .set(newEmployee.toJson());

      // **3. Tambahkan ID karyawan ke Store**
      await _firestore.collection('stores').doc(storeId).update({
        "employees": FieldValue.arrayUnion([employeeId])
      });

      Get.offAllNamed('/login'); // Arahkan ke halaman login

      Get.snackbar("Sukses", "Karyawan ${nameC.text} berhasil ditambahkan!");
      clearForm();
      Get.back(); // Kembali ke halaman sebelumnya
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
      Get.snackbar("Error", "Gagal membuat akun karyawan: ${e.message}");
    } on FirebaseException catch (e) {
      print("Firebase Error: ${e.message}");
      Get.snackbar("Error", "Gagal menambahkan karyawan: ${e.message}");
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Terjadi kesalahan, coba lagi.");
    } finally {
      isLoading.value = false;
    }
  }

  final listEmployee = [].obs;

  Future<void> getEmployee() async {
    final userId = _auth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();

    String? storeId;
    if (userDoc.exists) {
      storeId = userDoc.data()?['storeId']; // Untuk owner
    }

    // Jika storeId masih null, berarti user adalah karyawan dan storeId harus dicari
    if (storeId == null) {
      final storeQuery = await _firestore
          .collection('stores')
          .where('employees', arrayContains: userId)
          .get();

      if (storeQuery.docs.isNotEmpty) {
        storeId = storeQuery.docs.first.id;
      }
    }

    // Jika storeId tetap null, user tidak memiliki store
    if (storeId == null) {
      listEmployee.value = [];
      return;
    }

    final storeDoc = await _firestore.collection('stores').doc(storeId).get();
    final List<dynamic> employeeIdList =
        storeDoc.data()?['employees'] as List<dynamic>? ?? [];

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
    nameC.clear();
    emailC.clear();
    phoneC.clear();
    passwordC.clear();
    photoC.clear();
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    passwordC.dispose();
    photoC.dispose();
    super.onClose();
  }
}

// class AddEmployeeController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   var isLoading = false.obs;

//   final TextEditingController nameC = TextEditingController();
//   final TextEditingController emailC = TextEditingController();
//   final TextEditingController addressC = TextEditingController();
//   final TextEditingController phoneC = TextEditingController();
//   final TextEditingController passwordC = TextEditingController();
//   final TextEditingController photoC = TextEditingController();

//   var storeId = "".obs;
//   final listEmployee = <UserModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     getStoreId(); // Ambil storeId saat controller pertama kali dibuat
//     getEmployee();
//   }

//   Future<void> getStoreId() async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) return;

//     // Coba ambil store dari ownerId atau employeeId
//     final storeQuery = await _firestore
//         .collection('stores')
//         .where(Filter.or(
//           Filter("ownerId", isEqualTo: userId),
//           Filter("employees", arrayContains: userId),
//         ))
//         .get();

//     if (storeQuery.docs.isNotEmpty) {
//       storeId.value = storeQuery.docs.first.id;
//     } else {
//       storeId.value = ""; // Pastikan storeId kosong jika tidak ditemukan
//     }
//   }

//   Future<void> addEmployee() async {
//     if (nameC.text.isEmpty ||
//         emailC.text.isEmpty ||
//         phoneC.text.isEmpty ||
//         addressC.text.isEmpty ||
//         passwordC.text.isEmpty) {
//       Get.snackbar("Error", "Semua field harus diisi!");
//       return;
//     }

//     try {
//       isLoading.value = true;

//       if (storeId.value.isEmpty) {
//         Get.snackbar("Error", "Store tidak ditemukan.");
//         return;
//       }

//       // Cek apakah email sudah terdaftar
//       final userQuery = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: emailC.text)
//           .get();

//       if (userQuery.docs.isNotEmpty) {
//         Get.snackbar("Error", "Email sudah terdaftar sebagai karyawan!");
//         return;
//       }

//       // Buat akun karyawan
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: emailC.text,
//         password: passwordC.text,
//       );
//       final employeeId = userCredential.user!.uid;

//       // Simpan data karyawan ke Firestore
//       final newEmployee = UserModel(
//         id: employeeId,
//         name: nameC.text,
//         address: addressC.text,
//         email: emailC.text,
//         phoneNumber: phoneC.text,
//         photo: photoC.text,
//         role: "karyawan",
//         createdAt: DateTime.now().toIso8601String(),
//       );

//       await _firestore
//           .collection('users')
//           .doc(employeeId)
//           .set(newEmployee.toJson());

//       // Tambahkan karyawan ke dalam store
//       await _firestore.collection('stores').doc(storeId.value).update({
//         "employees": FieldValue.arrayUnion([employeeId])
//       });

//       Get.snackbar("Sukses", "Karyawan ${nameC.text} berhasil ditambahkan!");
//       clearForm();
//       Get.back();
//       getEmployee(); // Perbarui daftar karyawan
//     } on FirebaseAuthException catch (e) {
//       Get.snackbar("Error", "Gagal membuat akun: ${e.message}");
//     } catch (e) {
//       Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> getEmployee() async {
//     if (storeId.value.isEmpty) return;

//     final storeDoc =
//         await _firestore.collection('stores').doc(storeId.value).get();
//     final List<dynamic> employeeIdList =
//         storeDoc.data()?['employees'] as List<dynamic>? ?? [];

//     if (employeeIdList.isEmpty) {
//       listEmployee.clear();
//       return;
//     }

//     final employeeQuery = await _firestore
//         .collection('users')
//         .where(FieldPath.documentId, whereIn: employeeIdList)
//         .get();

//     listEmployee.value = employeeQuery.docs
//         .map((doc) => UserModel.fromJson(doc.data()))
//         .toList();
//   }

//   void clearForm() {
//     nameC.clear();
//     emailC.clear();
//     phoneC.clear();
//     passwordC.clear();
//     photoC.clear();
//   }

//   @override
//   void onClose() {
//     nameC.dispose();
//     emailC.dispose();
//     phoneC.dispose();
//     passwordC.dispose();
//     photoC.dispose();
//     super.onClose();
//   }
// }
