import '../../navbar/bindings/navbar_binding.dart';
import '../../navbar/views/navbar_view.dart';
import '../repositories/user_repository.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final userRepo = UserRepository();
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      // final res = await userRepo.login(email, password);
      Get.to(NavbarView(), binding: NavbarBinding());

      // res.fold(
      //   (failure) => Get.snackbar("Login Gagal", failure.message),
      //   (userCredential) {
      //     if (userCredential != null) {
      //       Get.snackbar("Login Berhasil", "Selamat datang kembali!");
      //     } else {
      //       Get.snackbar("Login Gagal", "Terjadi kesalahan saat login.");
      //     }
      //   },
      // );
    } catch (e) {
      Get.snackbar("Login Gagal", "Terjadi kesalahan saat login.");
    } finally {
      isLoading.value = false;
    }
  }
}
