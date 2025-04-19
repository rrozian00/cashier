import 'package:cashier/core/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/core/utils/get_user_data.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/bottom_navigation_bar/controllers/bottom_controller.dart';
import 'package:cashier/features/expense/controllers/expense_controller.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
  Future<void> fetchUserProfile() async {
    debugPrint("Fetchuserprofile dipanggil");

    userData.value = await getUserData();
    if (userData.value == null) return;
    debugPrint("setelah fetch,isi userdata:${userData.value?.name}");
  }

  Future<void> getOwner() async {
    // userData.value = await getUserData();

    debugPrint("getowner dipanggil");

    if (userData.value == null) return;
    if (userData.value?.role == "owner") {
      isOwner.value = true;
    } else {
      isOwner.value = false;
    }
    debugPrint("isOwner on Profile:$isOwner");
  }

  void showLogoutConfirm() {
    final tStyle = GoogleFonts.poppins(
      color: purple,
    );

    Get.defaultDialog(
      titleStyle: tStyle,
      title: "Keluar",
      content: Column(
        children: [
          Text(
            "Apakah anda yakin akan keluar?",
            style: tStyle,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myGreenElevated(
                width: 110,
                text: "Batal",
                onPress: () {
                  Get.back();
                },
              ),
              myRedElevated(
                width: 110,
                text: "Keluar",
                onPress: () => logout(),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> showEditProfile() async {
    if (userData.value == null) {
      return;
    }
    debugPrint("userData.nama di editProfil:${userData.value?.name}");

    final idUser = userData.value?.id;

    try {
      isLoading.value = true;

      Get.back();

      final newData = userData.value?.copyWith(
        name: name.value,
        address: address.value,
        phoneNumber: phone.value,
      );

      await firestore.collection("users").doc(idUser).update(newData!.toMap());

      Get.snackbar("Sukses", "Profil berhasil diperbarui.");
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui profil: $e");
    } finally {
      isLoading.value = false;
      fetchUserProfile();
    }
  }

  // 🔹 Logout Pengguna
  Future<void> showChangeDialog() async {
    if (newPass.value.isEmpty) {
      Get.snackbar("Error", "Password tidak boleh kosong!");
      return;
    } else if (newPass.value != reNewPass.value) {
      Get.snackbar("Eror", "Ulangi password tidak cocok");
      return;
    } else if (newPass.value == oldPass.value) {
      Get.snackbar("Eror", "Password baru tidak boleh sama dengan yang lama");
      return;
    }

    try {
      Get.back();
      isLoading.value = true;
      String email = auth.currentUser!.email!;

      // Minta ulang password sebelum update
      await auth.signInWithEmailAndPassword(
        email: email,
        password: oldPass.value, // Ubah dengan password lama
      );

      await auth.currentUser?.updatePassword(newPass.value);
      Get.snackbar("Sukses", "Password berhasil diubah");
      clearC();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        Get.snackbar("Error", "Passwor lama salah");
        return;
      } else if (e.code == 'too-many-requests') {
        Get.snackbar(
            "Error", "Terlalu banyak permintaan, Coba beberapa saat lagi");
      }
      debugPrint(e.code);
      Get.snackbar("Error", "Gagal mengubah password");
    } finally {
      isLoading.value = false;
      try {
        await auth.signOut();

        // Hapus semua instance controller yang tidak diperlukan
        Get.delete<ExpenseController>();
        Get.delete<OrderController>();
        Get.delete<BottomController>();

        Get.offAllNamed(Routes.login); // Pindah ke halaman login

        Get.snackbar("Sukses", "Berhasil logout!");
      } catch (e) {
        Get.snackbar("Error", "Gagal logout: ${e.toString()}");
      }
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();

      // Hapus semua instance controller yang tidak diperlukan
      Get.delete<ExpenseController>();
      Get.delete<OrderController>();
      Get.delete<BottomController>();

      Get.offAllNamed(Routes.bottom); // Pindah ke halaman login

      Get.snackbar("Sukses", "Berhasil logout!");
    } catch (e) {
      Get.snackbar("Error", "Gagal logout: ${e.toString()}");
    }
  }

  void clearC() {
    oldPass.value = '';
    newPass.value = '';
    reNewPass.value = '';
  }

  void clearField() {
    name.value = '';
    address.value = '';
    phone.value = '';
  }

  @override
  void onReady() async {
    super.onReady();
    await fetchUserProfile();
    await getOwner();
  }
}
