import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/my_alert_dialog.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../models/user_model.dart';
import '../blocs/edit_profile_bloc/edit_profile_bloc.dart';
import '../blocs/profile_bloc/profile_bloc.dart';

class EditProfileView extends StatefulWidget {
  final UserModel user;

  const EditProfileView({super.key, required this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameC;
  late TextEditingController addressC;
  late TextEditingController phoneC;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.user.name ?? '');
    addressC = TextEditingController(text: widget.user.address ?? '');
    phoneC = TextEditingController(text: widget.user.phoneNumber ?? '');
  }

  @override
  void dispose() {
    nameC.dispose();
    addressC.dispose();
    phoneC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
      if (state is EditProfileSuccess) {
        Navigator.pop(context);
        context.read<ProfileBloc>().add(ProfileFetched());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Profil berhasil diubah!"),
        ));
      } else if (state is EditProfileError) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(state.message),
              );
            });
      }
    }, builder: (context, state) {
      if (state is EditProfileLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return Padding(
        padding: EdgeInsets.only(
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                "Ubah Profil",
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
            SizedBox(height: 15),
            MyTextField(controller: nameC, hint: "Nama", label: "Nama"),
            MyTextField(controller: addressC, label: "Alamat", hint: "Alamat"),
            MyTextField(
              textInputType: TextInputType.number,
              controller: phoneC,
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
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary),
                  child: Text("simpan"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return MyAlertDialog(
                            onConfirm: () {
                              context.read<EditProfileBloc>().add(
                                    EditProfileSubmitted(
                                      user: widget.user,
                                      name: nameC.text,
                                      address: addressC.text,
                                      phone: phoneC.text,
                                    ),
                                  );
                            },
                            contentText: "Anda yakin akan menyimpan data?",
                          );
                        });
                  },
                ),
              ],
            ),
            SizedBox(height: 40)
          ],
        ),
      );
    });
  }
}
