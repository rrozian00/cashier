import 'package:cashier/core/widgets/my_snackbar.dart';

import '../../../navbar/views/navbar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/my_text_field.dart';
import '../bloc/login_bloc.dart';
import '../../register/views/register_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  // final TextEditingController emailC = TextEditingController();
  // final TextEditingController passwordC = TextEditingController();
  // final TextEditingController emailC =
  //     TextEditingController(text: "rrozian123@gmail.com");
  // final TextEditingController passwordC = TextEditingController(text: "123123");
  final TextEditingController emailC =
      TextEditingController(text: "rrozian00@gmail.com");
  final TextEditingController passwordC = TextEditingController(text: "123123");

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isLoading == false && state.user != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavbarView(),
              ));
        } else if (state.message != null) {
          mySnackbar(context, state.message ?? '', isError: true);
        }
      },
      child: Scaffold(
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
                    BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                      return MyTextField(
                        suffixIcon: IconButton(
                          onPressed: () => context
                              .read<LoginBloc>()
                              .add(PasswordVisibilityTogled()),
                          icon: Icon(
                            state.obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        filled: true,
                        textCapitalization: TextCapitalization.none,
                        controller: passwordC,
                        label: "Password",
                        hint: "Password",
                        obscure: state.obscure,
                        validator: (value) => value == null || value.isEmpty
                            ? "Password tidak boleh kosong"
                            : null,
                      );
                    }),
                    SizedBox(height: 20),
                    Center(
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if (state.isLoading == false) {
                            return ElevatedButton(
                              // width: MediaQuery.of(context).size.width * 0.8,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginBloc>().add(LoginSubmitted(
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
