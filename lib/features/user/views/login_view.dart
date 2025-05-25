import '../../../core/theme/colors.dart';
import '../../../core/widgets/my_elevated.dart';
import '../../../core/widgets/my_text_field.dart';
import '../blocs/auth/auth_bloc.dart';
import 'register_view.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedState) {
          Get.offAllNamed(
            Routes.bottom,
          );
        } else if (state is AuthFailedState) {
          debugPrint(state.message.toString());
          Get.offAllNamed(Routes.login);
          Get.snackbar("Error", state.message);
        }
      },
      child: Scaffold(
        backgroundColor: softGrey,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
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
                      filled: true,
                      color: white,
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
                    MyText(
                      filled: true,
                      color: white,
                      textCapitalization: TextCapitalization.none,
                      controller: passwordC,
                      label: "Password",
                      hint: "Password",
                      obscure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: myElevated(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthLoginEvent(
                                email: emailC.text, password: passwordC.text));
                          }
                        },
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoadingState) {
                              return CircularProgressIndicator.adaptive();
                            }
                            return Text(
                              "Login",
                              style: GoogleFonts.montserrat(fontSize: 18),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    Row(
                      children: [
                        Text("Belum punya akun?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterView(),
                                ));
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
      ),
    );
  }
}
