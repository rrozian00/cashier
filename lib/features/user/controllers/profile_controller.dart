import 'package:cashier/core/widgets/my_alert_dialog.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/core/utils/get_user_data.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/bottom_navigation_bar/controllers/bottom_controller.dart';
import 'package:cashier/features/expense/controllers/expense_controller.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:cashier/routes/app_pages.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var userData = Rxn<UserModel>();

  final isLoading = false.obs;
  final isOwner = false.obs;

  final name = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;

  final oldPass = ''.obs;
  final newPass = ''.obs;
  final reNewPass = ''.obs;

  // 🔹 Ambil data user dari Firestore
  void fetchUserProfile() async {
    userData.value = await getUserData();
    if (userData.value == null) return;

    final doc = await getUserData();
    debugPrint(doc?.name);
  }

  void getOwner() async {
    userData.value = await getUserData();

    debugPrint("getowner dipanggil");

    if (userData.value == null) return;
    if (userData.value?.role == "owner") {
      isOwner.value = true;
    } else {
      isOwner.value = false;
    }
    debugPrint("isOwner on Profile:$isOwner");
  }

  void editProfile() async {
    Get.dialog(MyAlertDialog(
        onConfirm: () async {
          if (userData.value == null) {
            Get.snackbar("Error", "Data user tidak ditemukan!");
            return;
          }

          final idUser = userData.value?.id;

          try {
            if (userData.value?.role == "owner") {
              Get.until(
                (route) => Get.currentRoute == Routes.profile,
              );
            } else {
              Get.back();
              Get.back();
            }
            isLoading.value = true;
            // Buat salinan data user dengan data baru langsung dari input
            final newData = userData.value?.copyWith(
              name: name.value,
              address: address.value,
              phoneNumber: phone.value,
            );

            await _db.collection("users").doc(idUser).update(newData!.toMap());

            Get.snackbar("Sukses", "Profil berhasil diperbarui.");
          } catch (e) {
            Get.snackbar("Error", "Gagal memperbarui profil: $e");
          } finally {
            isLoading.value = false;
          }
        },
        contentText: "Anda yakin akan menyimpan data?"));
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
              myGreenElevated(
                text: "Batal",
                onPress: () {
                  Get.back();
                },
              ),
              myRedElevated(
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
          MyTextField(
            label: "Password Lama",
            controller: oldPass,
            obscure: true,
          ),
          MyTextField(
            label: "Password Baru",
            controller: newPass,
            obscure: true,
          ),
          MyTextField(
            label: "Ulangi Password Baru",
            controller: reNewPass,
            obscure: true,
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
                  if (newPass.value.isEmpty) {
                    Get.snackbar("Error", "Password tidak boleh kosong!");
                    return;
                  } else if (newPass.value != newPass.value) {
                    Get.snackbar("Eror", "Password baru tidak sama");
                    return;
                  } else if (newPass.value == oldPass.value) {
                    Get.snackbar("Eror",
                        "Password baru tidak boleh sama dengan yang lama");
                    return;
                  }

                  try {
                    Get.back();
                    isLoading.value = true;
                    String email = _auth.currentUser!.email!;

                    // 🔹 Minta ulang password sebelum update
                    await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: oldPass.value, // Ubah dengan password lama
                    );

                    await _auth.currentUser?.updatePassword(newPass.value);
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
                    debugPrint(e.code);
                    Get.snackbar("Error", "Gagal mengubah password");
                  } finally {
                    isLoading.value = false;
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
    oldPass.value = '';
    newPass.value = '';
    reNewPass.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    getOwner();
  }
}
