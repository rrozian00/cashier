import '../../../core/utils/my_loading.dart';
import '../../../core/widgets/my_text_field.dart';
import '../controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final TextEditingController emailC =
      TextEditingController(text: "rrozian00@gmail.com");
  final TextEditingController passwordC = TextEditingController(text: "123123");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        color: Theme.of(context).colorScheme.primary,
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
                  MyTextField(
                    filled: true,
                    textCapitalization: TextCapitalization.none,
                    textInputType: TextInputType.emailAddress,
                    controller: emailC,
                    label: "Email",
                    hint: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => MyTextField(
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.obscurePassword.toggle();
                          },
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        filled: true,
                        textCapitalization: TextCapitalization.none,
                        controller: passwordC,
                        label: "Password",
                        hint: "Password",
                        obscure: controller.obscurePassword.value,
                        validator: (value) => value == null || value.isEmpty
                            ? "Password tidak boleh kosong"
                            : null,
                      )),
                  SizedBox(height: 20),
                  Obx(() => ElevatedButton(
                        onPressed: () {
                          controller.login(emailC.text, passwordC.text);
                        },
                        child: controller.isLoading.value
                            ? myLoading()
                            : Text(
                                "Login",
                                style: GoogleFonts.montserrat(fontSize: 14),
                              ),
                      )),
                  SizedBox(height: 100),
                  Row(
                    children: [
                      Text("Belum punya akun?"),
                      TextButton(
                        onPressed: () {},
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
