import 'package:cashier/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/user/blocs/register/register_bloc.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cashier/features/user/views/login_view.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController passwordConfirmC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController phoneNumberC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          Navigator.pushReplacementNamed(context, Routes.login);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Berhasil Registrasi, Silahkan Login !")));
        }
      },
      child: Scaffold(
        backgroundColor: softGrey,
        appBar: MyAppBar(titleText: "Registrasi Akun"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText(
                    filled: true,
                    controller: nameC,
                    label: "Nama",
                    hint: "Nama",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  MyText(
                    filled: true,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                    controller: emailC,
                    label: "Email",
                    hint: "Email",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Email tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  MyText(
                    filled: true,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.next,
                    controller: passwordC,
                    label: "Password",
                    hint: "Password",
                    obscure: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Password tidak boleh kosong";
                      } else if (v != passwordConfirmC.text) {
                        return "Pasword tidak sama";
                      }
                      return null;
                    },
                  ),
                  MyText(
                    filled: true,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.next,
                    controller: passwordConfirmC,
                    label: "Ulangi Password",
                    hint: "Ulangi Password",
                    obscure: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Password tidak boleh kosong";
                      } else if (v != passwordC.text) {
                        return "Pasword tidak sama";
                      }
                      return null;
                    },
                  ),
                  MyText(
                    filled: true,
                    controller: addressC,
                    label: "Alamat",
                    hint: "Alamat",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Alamat tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  MyText(
                    filled: true,
                    textInputAction: TextInputAction.next,
                    controller: phoneNumberC,
                    label: "Nomor Handphone",
                    hint: "Nomor Handphone",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Nomor Handphone tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  myElevated(
                    height: 50,
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<RegisterBloc>().add(RegisterRequestedEvent(
                            user: UserModel(
                              email: emailC.text,
                              name: nameC.text,
                              address: addressC.text,
                              role: "owner",
                              phoneNumber: phoneNumberC.text,
                              createdAt: Timestamp.now(),
                            ),
                            password: passwordC.text));
                      }
                    },
                    child: BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterLoadingState) {
                          return CircularProgressIndicator();
                        }
                        return Text(
                          "Daftar",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Text("Sudah punya akun?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginView(),
                              ));
                        },
                        child: const Text("Login"),
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
