// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../core/widgets/my_alert_dialog.dart';
// import '../../../../core/widgets/my_text_field.dart';
// import '../../models/user_model.dart';
// import '../blocs/edit_profile_bloc/edit_profile_bloc.dart';
// import '../blocs/profile_bloc/profile_bloc.dart';

// class EditProfileView extends StatefulWidget {
//   final UserModel user;

//   const EditProfileView({super.key, required this.user});

//   @override
//   State<EditProfileView> createState() => _EditProfileViewState();
// }

// class _EditProfileViewState extends State<EditProfileView> {
//   late TextEditingController nameC;
//   late TextEditingController addressC;
//   late TextEditingController phoneC;

//   @override
//   void initState() {
//     super.initState();
//     nameC = TextEditingController(text: widget.user.name ?? '');
//     addressC = TextEditingController(text: widget.user.address ?? '');
//     phoneC = TextEditingController(text: widget.user.phoneNumber ?? '');
//   }

//   @override
//   void dispose() {
//     nameC.dispose();
//     addressC.dispose();
//     phoneC.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<EditProfileBloc, EditProfileState>(
//         listener: (context, state) {
//       if (state is EditProfileSuccess) {
//         Navigator.pop(context);
//         context.read<ProfileBloc>().add(ProfileFetched());
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("Profil berhasil diubah!"),
//         ));
//       } else if (state is EditProfileError) {
//         showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text("Error"),
//                 content: Text(state.message),
//               );
//             });
//       }
//     }, builder: (context, state) {
//       if (state is EditProfileLoading) {
//         return Center(child: CircularProgressIndicator());
//       }
//       return Padding(
//         padding: EdgeInsets.only(
//             right: 10,
//             left: 10,
//             bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Center(
//               child: Text(
//                 "Ubah Profil",
//                 style: GoogleFonts.poppins(fontSize: 18),
//               ),
//             ),
//             SizedBox(height: 15),
//             MyTextField(controller: nameC, hint: "Nama", label: "Nama"),
//             MyTextField(controller: addressC, label: "Alamat", hint: "Alamat"),
//             MyTextField(
//               textInputType: TextInputType.number,
//               controller: phoneC,
//               label: "No HP",
//               hint: "No HP",
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   // text: "Batal",
//                   child: Text("Batal"),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).colorScheme.tertiary),
//                   child: Text("simpan"),
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) {
//                           return MyAlertDialog(
//                             onConfirm: () {
//                               context.read<EditProfileBloc>().add(
//                                     EditProfileSubmitted(
//                                       user: widget.user,
//                                       name: nameC.text,
//                                       address: addressC.text,
//                                       phone: phoneC.text,
//                                     ),
//                                   );
//                             },
//                             contentText: "Anda yakin akan menyimpan data?",
//                           );
//                         });
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 40)
//           ],
//         ),
//       );
//     });
//   }
// }
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
          // 🔹 SOLUSI UTAMA: Sekarang pop di sini murni menutup BottomSheet edit profil
          Navigator.pop(context);

          context.read<ProfileBloc>().add(ProfileFetched());

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Profil berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ));
        } else if (state is EditProfileError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Gagal Menyimpan"),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          // Responsif mengikuti tinggi keyboard virtual HP kasir
          padding: EdgeInsets.only(
            right: 16,
            left: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "Ubah Informasi Profil",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                MyTextField(
                    controller: nameC, hint: "Nama Lengkap", label: "Nama"),
                const SizedBox(height: 12),
                MyTextField(
                    controller: addressC, label: "Alamat Toko", hint: "Alamat"),
                const SizedBox(height: 12),
                MyTextField(
                  textInputType: TextInputType.phone,
                  controller: phoneC,
                  label: "Nomor HP Kasir",
                  hint: "Contoh: 0812345678",
                ),
                const SizedBox(height: 28),
                if (state is EditProfileLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            // Validasi form dasar agar tidak mengirim string kosong
                            if (nameC.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Nama tidak boleh kosong"),
                                backgroundColor: Colors.orange,
                              ));
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return MyAlertDialog(
                                  onConfirm: () {
                                    // 1. Tutup dialog konfirmasinya terlebih dahulu menggunakan dialogContext
                                    Navigator.pop(dialogContext);

                                    // 2. Kirim data baru ke blok untuk disimpan ke Supabase
                                    context.read<EditProfileBloc>().add(
                                          EditProfileSubmitted(
                                            user: widget.user,
                                            name: nameC.text,
                                            address: addressC.text,
                                            phone: phoneC.text,
                                          ),
                                        );
                                  },
                                  contentText:
                                      "Apakah Anda yakin semua perubahan data profil sudah benar?",
                                );
                              },
                            );
                          },
                          child: const Text("Simpan",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
