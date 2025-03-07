import 'package:cashier/app/modules/bottom/controllers/bottom_controller.dart';
import 'package:cashier/app/modules/expense/controllers/expense_controller.dart';
import 'package:cashier/app/modules/order/controllers/order_controller.dart';
import 'package:cashier/app/routes/app_pages.dart';
import 'package:cashier/utils/my_elevated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var user = Rxn<User>();

  final name = ''.obs;
  final role = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;
  final photo = ''.obs;
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordReEnter = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    once(user, (user) {
      if (user != null) fetchUserProfile();
    });
    // fetchUserProfile();
  }

  // 🔹 Ambil data user dari Firestore
  Future<void> fetchUserProfile() async {
    debugPrint(user.value.toString());
    if (user.value == null) return;

    final doc = await _db.collection("users").doc(user.value!.uid).get();
    print("Data Firestore: ${doc.data()}");
    if (doc.exists) {
      name.value = doc["name"];
      role.value = doc["role"] == 'owner' ? "Owner" : "Karyawan";
      address.value = doc.data()?['address'];
      phone.value = doc.data()?['phoneNumber'];
      photo.value = doc.data()?['photo'];
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    print(user.value!.uid);
    if (image != null) {
      await _db
          .collection('users')
          .doc(user.value!.uid)
          .update({'photo': image.path});
      await fetchUserProfile();
      Get.snackbar("Sukses", "Berhasil ubah foto profil");
      update();
    } else {
      Get.snackbar("Gagal", "Error");
      return;
    }
  }

  void showLogoutConfirm() {
    Get.defaultDialog(
      title: "Keluar",
      content: Column(
        children: [
          Text("Apakah anda yakin akan keluar?"),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myElevated(
                text: "Batal",
                onPress: () {
                  Get.back();
                },
              ),
              myElevated(
                text: "Keluar",
                onPress: () => logout(),
              )
            ],
          )
        ],
      ),
    );
  }

  // 🔹 Logout Pengguna
  Future<void> logout() async {
    try {
      await _auth.signOut();

      // Hapus semua instance controller yang tidak diperlukan
      Get.delete<ExpenseController>();
      Get.delete<OrderController>();
      Get.delete<BottomController>();

      user.value = null; // Hapus user yang login
      role.value = ""; // Reset role agar tidak membawa data lama

      Get.offAllNamed(Routes.LOGIN); // Pindah ke halaman login

      Get.snackbar("Sukses", "Berhasil logout!");
    } catch (e) {
      Get.snackbar("Error", "Gagal logout: ${e.toString()}");
    }
  }

  // 🔹 Ubah Password dengan Re-authentication
  void changePassword() {
    Get.defaultDialog(
      title: "Ubah Password",
      content: Column(
        children: [
          TextField(
            controller: oldPassword,
            decoration: const InputDecoration(labelText: "Password Lama"),
            obscureText: true,
          ),
          TextField(
            controller: newPassword,
            decoration: const InputDecoration(labelText: "Password Baru"),
            obscureText: true,
          ),
          TextField(
            controller: newPasswordReEnter,
            decoration:
                const InputDecoration(labelText: "Ulangi Password Baru"),
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myElevated(
                text: "Batal",
                onPress: () {
                  Get.back();
                  clearC();
                },
              ),
              myElevated(
                text: "Simpan",
                onPress: () async {
                  if (newPassword.text.isEmpty) {
                    Get.snackbar("Error", "Password tidak boleh kosong!");
                    return;
                  } else if (newPassword.text != newPasswordReEnter.text) {
                    Get.snackbar("Eror", "Password baru tidak sama");
                    return;
                  } else if (newPassword.text == oldPassword.text) {
                    Get.snackbar("Eror",
                        "Password baru tidak boleh sama dengan yang lama");
                    return;
                  }

                  try {
                    String email = user.value!.email!;

                    // 🔹 Minta ulang password sebelum update
                    await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: oldPassword.text, // Ubah dengan password lama
                    );

                    await user.value!.updatePassword(newPassword.text);
                    Get.back();
                    Get.snackbar("Sukses", "Password berhasil diubah");
                    clearC();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-credential') {
                      Get.snackbar("Error", "Passwor lama salah");
                      return;
                    } else if (e.code == 'too-many-requests') {
                      Get.snackbar("Error",
                          "Terlalu banyak permintaan, Coba beberapa saat lagi");
                    }
                    print(e.code);
                    Get.snackbar("Error", "Gagal mengubah password");
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void clearC() {
    oldPassword.clear();
    newPassword.clear();
    newPasswordReEnter.clear();
  }
}
