// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:cashier/core/widgets/my_alert_dialog.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/user/blocs/auth/auth_bloc.dart';
import 'package:cashier/features/user/blocs/register/register_bloc.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileView extends StatefulWidget {
  final UserModel user;

  const EditProfileView({super.key, required this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameC;
  late TextEditingController addressC;
  late TextEditingController phoneNumberC;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.user.name ?? '');
    addressC = TextEditingController(text: widget.user.address ?? '');
    phoneNumberC = TextEditingController(text: widget.user.phoneNumber ?? '');
  }

  @override
  void dispose() {
    nameC.dispose();
    addressC.dispose();
    phoneNumberC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is EditSuccessState) {
          //  Navigator.popUntil(
          //         context, (route) => route.settings.name == Routes.profile)
          Get.back();
          context.read<AuthBloc>().add(AuthCheckStatusEvent());
        }
      },
      builder: (context, state) {
        if (state is RegisterLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: Column(
              children: [
                homeIndicator(),
                Expanded(
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          "Ubah Profil",
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 15),
                      MyTextField(
                          controller: nameC, hint: "Nama", label: "Nama"),
                      MyTextField(
                          controller: addressC,
                          label: "Alamat",
                          hint: "Alamat"),
                      MyTextField(
                        textInputType: TextInputType.number,
                        controller: phoneNumberC,
                        label: "No HP",
                        hint: "No HP",
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            // text: "Batal",
                            child: Text("Batal"),
                            onPressed: () => Get.back(),
                          ),
                          ElevatedButton(
                            // text: "Simpan",
                            child: Text("simpan"),
                            onPressed: () {
                              Get.dialog(MyAlertDialog(
                                onConfirm: () {
                                  context.read<RegisterBloc>().add(
                                        EditRequestedEvent(
                                          name: nameC.text,
                                          address: addressC.text,
                                          phone: phoneNumberC.text,
                                        ),
                                      );
                                },
                                contentText: "Anda yakin akan menyimpan data?",
                              ));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 40)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
