import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.blue[200]!,
          Colors.white,
          Colors.deepPurple[200]!
        ])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/icon.png',
                        width: 100,
                      ),
                      Text(
                        "Cashier",
                        style: GoogleFonts.lobster(fontSize: 50),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                        "Silahkan Login dengan e-mail Anda,\nJika belum punya akun silahkan klik Daftar!"),
                  ),
                  MyText(
                    textCapitalization: TextCapitalization.none,
                    textInputType: TextInputType.emailAddress,
                    controller: controller.emailController,
                    label: "Email",
                    hint: "Email",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyText(
                    textCapitalization: TextCapitalization.none,
                    controller: controller.passwordController,
                    label: "Password",
                    hint: "Password",
                    obscure: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : myElevated(
                          onPress: controller.isLoading.value
                              ? null
                              : controller.login,
                          text: "Login",
                        )),
                  Row(
                    children: [
                      Text("Belum punya akun?"),
                      TextButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                Get.to(() => const RegisterView());
                              },
                        child: const Text("Daftar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure,
    this.textInputType,
    this.textCapitalization,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool? obscure;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(label),
        // SizedBox(height: 4),
        TextField(
          textCapitalization: textCapitalization ?? TextCapitalization.words,
          obscureText: obscure ?? false,
          textInputAction: textInputAction ?? TextInputAction.next,
          controller: controller,
          keyboardType: textInputType,
          decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class RegisterView extends GetView<LoginController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Akun")),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.white, Colors.deepPurple])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(
                  controller: controller.nameRegister,
                  label: "Nama",
                  hint: "Nama",
                ),
                MyText(
                  controller: controller.addressRegister,
                  label: "Alamat",
                  hint: "Alamat",
                ),
                MyText(
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                  controller: controller.emailRegister,
                  label: "Email",
                  hint: "Email",
                ),
                MyText(
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  controller: controller.passwordRegister,
                  label: "Password",
                  hint: "Password",
                  obscure: true,
                ),
                MyText(
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  controller: controller.passwordConfirm,
                  label: "Ulangi Password",
                  hint: "Ulangi Password",
                  obscure: true,
                ),
                MyText(
                  textInputAction: TextInputAction.next,
                  controller: controller.phoneNumberRegister,
                  label: "No Handphone",
                  hint: "No Handphone",
                ),
                const SizedBox(height: 20),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : myElevated(
                        onPress: controller.isLoading.value
                            ? null
                            : controller.register,
                        text: "Daftar",
                      )),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Text("Sudah punya akun?"),
                    TextButton(
                      onPressed:
                          controller.isLoading.value ? null : () => Get.back(),
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
