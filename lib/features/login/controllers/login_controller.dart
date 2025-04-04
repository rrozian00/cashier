import 'package:cashier/features/user/models/user_model.dart';

import 'package:cashier/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<User>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController(text: "123123");

  final emailRegister = TextEditingController();
  final addressRegister = TextEditingController();
  final passwordRegister = TextEditingController();
  final passwordConfirm = TextEditingController();
  final nameRegister = TextEditingController();
  final phoneNumberRegister = TextEditingController();
  final role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_firebaseAuth.authStateChanges());
  }

  // 🔹 Register Pengguna Baru & Simpan ke Firestore
  Future<void> register() async {
    if (emailRegister.text.isEmpty ||
        passwordRegister.text.isEmpty ||
        addressRegister.text.isEmpty ||
        nameRegister.text.isEmpty) {
      Get.snackbar("Error", "Semua kolom harus diisi!");
      return;
    }
    if (passwordRegister.text != passwordConfirm.text) {
      Get.snackbar("Eror", "Password tidak cocok");
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailRegister.text,
        password: passwordRegister.text,
      );

      String uid = userCredential.user!.uid;

      final data = UserModel(
        id: uid,
        name: nameRegister.text,
        email: emailRegister.text,
        role: 'owner',
        phoneNumber: phoneNumberRegister.text,
        createdAt: DateTime.now().toIso8601String(),
      );
      await _firestore.collection('users').doc(uid).set(data.toJson());

      user.value = userCredential.user;
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
          "Sukses", "Anda telah berhasil membuat akun, silahkan login!");
    } on FirebaseAuthException catch (e) {
      // Get.snackbar("Error", "Gagal registrasi: ${e.toString()}");
      if (e.code == 'The email address is badly formatted.') {
        Get.snackbar("Error", "Email tidak benar");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Login Pengguna & Cek Role
  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email dan password harus diisi!");
      return;
    }

    try {
      isLoading.value = true;

      // Proses login
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      user.value = userCredential.user; // Simpan user yang login

      // Ambil data user dari Firestore
      DocumentSnapshot<Map<String, dynamic>> userData = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userData.exists) {
        Get.snackbar("Error", "User tidak ditemukan di database!");
        return;
      }

      // Ambil role dari Firestore
      role.value = userData.data()?['role'] ?? 'karyawan';

      // Navigasi ke halaman sesuai role
      Get.offAllNamed(Routes.BOTTOM, arguments: role.value);

      Get.snackbar("Sukses",
          "Berhasil login sebagai ${role.value == 'owner' ? 'Owner' : 'Karyawan'}!");
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Terjadi kesalahan saat login";

      // Tangani error FirebaseAuth
      if (e.code == 'user-not-found') {
        errorMessage = "Email tidak terdaftar!";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Password salah!";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Format email tidak valid!";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Terlalu banyak percobaan login. Coba lagi nanti!";
      }

      Get.snackbar("Error", errorMessage);
    } catch (e) {
      Get.snackbar("Error", "Gagal login: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserRole() async {
    final FirebaseFirestore fire = FirebaseFirestore.instance;
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userData =
          await fire.collection("users").doc(currentUser.uid).get();

      if (userData.exists) {
        role.value = userData['role'];
      } else {
        // Get.snackbar("Error", "Akun tidak ditemukan!");
        await _firebaseAuth.signOut();
      }
    }
  }
}
