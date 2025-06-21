import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/my_text_field.dart';
import '../blocs/auth/auth_bloc.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key, required this.email});

  final String email;
  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late TextEditingController email;
  final TextEditingController oldPass = TextEditingController();
  final TextEditingController newPass = TextEditingController();
  final TextEditingController newPassAgain = TextEditingController();

  @override
  void initState() {
    email = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Ubah Password",
                  style: GoogleFonts.poppins(
                      fontSize: 20, color: colorScheme.primary),
                ),
              ),
              SizedBox(height: 20),
              MyTextField(
                filled: true,
                fill: Theme.of(context).disabledColor,
                readOnly: true,
                textCapitalization: TextCapitalization.none,
                textInputType: TextInputType.emailAddress,
                label: "Email",
                hint: "Email",
                controller: email,
              ),
              MyTextField(
                label: "Password Lama",
                hint: "Password Lama",
                controller: oldPass,
                obscure: true,
              ),
              MyTextField(
                label: "Password Baru",
                hint: "Password Baru",
                controller: newPass,
                obscure: true,
              ),
              MyTextField(
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
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
      ),
    );
  }
}
