import '../../../core/theme/colors.dart';

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

  // final TextEditingController emailC = TextEditingController();
  // final TextEditingController passwordC = TextEditingController();
  final TextEditingController emailC =
      TextEditingController(text: "rrozian00@gmail.com");
  final TextEditingController passwordC =
      TextEditingController(text: "1231231");

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
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isObscure = state is UnauthenticatedState
                            ? state.isObsecure
                            : true;
                        final hasToggle = state is UnauthenticatedState;

                        return MyText(
                          suffixIcon: IconButton(
                            onPressed: hasToggle
                                ? () =>
                                    context.read<AuthBloc>().add(SeePassword())
                                : null,
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                          filled: true,
                          color: white,
                          textCapitalization: TextCapitalization.none,
                          controller: passwordC,
                          label: "Password",
                          hint: "Password",
                          obscure: isObscure,
                          validator: (value) => value == null || value.isEmpty
                              ? "Password tidak boleh kosong"
                              : null,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is! AuthLoadingState) {
                            return ElevatedButton(
                              // width: MediaQuery.of(context).size.width * 0.8,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(AuthLoginEvent(
                                      email: emailC.text,
                                      password: passwordC.text));
                                }
                              },
                              child: Text(
                                "Login",
                                style: GoogleFonts.montserrat(fontSize: 14),
                              ),
                            );
                          }

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
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
