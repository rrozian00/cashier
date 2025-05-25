import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';
import '../../../core/widgets/my_alert_dialog.dart';
import '../../../core/widgets/my_appbar.dart';
import '../../../core/widgets/my_elevated.dart';
import '../../../routes/app_pages.dart';
import '../../bottom_navigation_bar/cubit/bottom_nav_cubit.dart';
import '../blocs/auth/auth_bloc.dart';
import '../models/user_model.dart';
import 'change_password.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          // Get.offAllNamed(Routes.login);
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => SplashScreen(),
          //     ));
          Navigator.pushReplacementNamed(context, Routes.login);
        } else if (state is AuthLoggedState) {
          // print("State nya ini");
          showDialog(
            context: context,
            builder: (context) {
              return MySingleAlertDialog(
                  onCancelText: "Kembali",
                  contentText:
                      "Link verifikasi sudah dikirim ke email ${state.user.email},\nSilahkan cek email anda !");
            },
          );
        }
        if (state is ChangePassSuccess) {
          if (context.mounted) {
            context.read<AuthBloc>().add(AuthLogoutEvent());
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Berhasil ubah password")));
          }
        }
      },
      child: Scaffold(
        backgroundColor: softGrey,
        appBar: MyAppBar(
          titleText: "Profil",
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoggedState) {
                  return IconButton(
                    icon: Icon(Icons.edit_square, color: blue),
                    onPressed: () => showModalBottomSheet(
                      clipBehavior: Clip.hardEdge,
                      scrollControlDisabledMaxHeightRatio: 0.9,
                      context: context,
                      builder: (context) => EditProfileView(user: state.user),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return Center(child: CircularProgressIndicator.adaptive());
            }

            if (state is AuthLoggedState) {
              final user = state.user;
              return _buildProfileBody(context, user, state.verification);
            }

            return Center(child: Text("Gagal memuat state"));
          },
        ),
      ),
    );
  }

  Widget _buildProfileBody(
      BuildContext context, UserModel user, bool verification) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: !verification,
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthSendVerification());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 40,
                      color: Colors.amber,
                    ),
                    Text("Kirim link verifikasi ke email saya"),
                  ],
                ),
              ),
            ),
            _buildProfileItem(Icons.person, "Nama", user.name ?? "-"),
            Divider(),
            _buildProfileItem(Icons.email, "Email", user.email ?? "-"),
            Divider(),
            _buildProfileItem(Icons.location_on, "Alamat", user.address ?? "-"),
            Divider(),
            _buildProfileItem(Icons.phone, "Telepon", user.phoneNumber ?? "-"),
            Divider(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                myPurpleElevated(
                  width: MediaQuery.of(context).size.width / 2.5,
                  onPress: () {
                    showModalBottomSheet(
                      clipBehavior: Clip.hardEdge,
                      scrollControlDisabledMaxHeightRatio: 0.9,
                      context: context,
                      builder: (_) => ChangePasswordView(),
                    );
                  },
                  text: "Ubah Password",
                ),
                myRedElevated(
                  width: MediaQuery.of(context).size.width / 2.5,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MyAlertDialog(
                          onConfirmText: "Keluar",
                          onCancelColor: green,
                          onConfirmColor: red,
                          onConfirm: () {
                            context.read<AuthBloc>().add(AuthLogoutEvent());
                            context.read<BottomNavCubit>().updateIndex(0);
                          },
                          contentText: "Anda yakin akan keluar?",
                        );
                      },
                    );
                  },
                  text: "Keluar",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk Item Profil
  Widget _buildProfileItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: purple),
      title:
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      subtitle: Text(value, key: ValueKey(value), style: GoogleFonts.poppins()),
    );
  }
}
