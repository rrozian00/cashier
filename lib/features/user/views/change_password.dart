import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';
import '../../../core/widgets/home_indicator.dart';

import '../../../core/widgets/my_text_field.dart';
import '../blocs/auth/auth_bloc.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController email = TextEditingController();

  final TextEditingController oldPass = TextEditingController();

  final TextEditingController newPass = TextEditingController();

  final TextEditingController newPassAgain = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          return Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: softGrey,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Column(
            children: [
              homeIndicator(),
              Expanded(
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        "Ubah Password",
                        style: GoogleFonts.poppins(fontSize: 20, color: purple),
                      ),
                    ),
                    SizedBox(height: 20),
                    MyText(
                      textCapitalization: TextCapitalization.none,
                      textInputType: TextInputType.emailAddress,
                      label: "Email",
                      hint: "Email",
                      controller: email,
                    ),
                    MyText(
                      label: "Password Lama",
                      hint: "Password Lama",
                      controller: oldPass,
                      obscure: true,
                    ),
                    MyText(
                      label: "Password Baru",
                      hint: "Password Baru",
                      controller: newPass,
                      obscure: true,
                    ),
                    MyText(
                      label: "Ulangi Password Baru",
                      hint: "Ulangi Password Baru",
                      controller: newPassAgain,
                      obscure: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          child: Text("Batal"),
                          // width: 150,
                          // text: "Batal",
                          onPressed: () async {
                            Get.back();
                          },
                        ),
                        ElevatedButton(
                          child: Text("Simpan"),
                          // width: 150,
                          // text: "Simpan",
                          onPressed: () {
                            context.read<AuthBloc>().add(ChangePasswordPressed(
                                  email: email.text,
                                  oldPass: oldPass.text,
                                  newPass: newPass.text,
                                ));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
