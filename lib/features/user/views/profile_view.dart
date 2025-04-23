import 'package:cashier/core/widgets/my_alert_dialog.dart';
import 'package:cashier/features/user/blocs/auth/auth_bloc.dart';
import 'package:cashier/features/bottom_navigation_bar/cubit/bottom_nav_cubit.dart';
import 'package:cashier/features/user/blocs/register/register_bloc.dart';
import 'package:cashier/features/user/views/change_password.dart';
import 'package:cashier/features/user/views/edit_profile_view.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is UnauthenticatedState) {
          await Future.delayed(Duration(milliseconds: 500));
          Get.offAllNamed(Routes.login);
        }
        if (state is ChangePassSuccess) {
          // Navigator.pushReplacementNamed(context, Routes.login);
          context.read<AuthBloc>().add(AuthLogoutEvent());
          Get.snackbar("Sukses", "Berhasil ubah password");
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: softGrey,
              appBar: MyAppBar(
                titleText: "Profil",
                actions: [
                  IconButton(
                      onPressed: () => showModalBottomSheet(
                            clipBehavior: Clip.hardEdge,
                            scrollControlDisabledMaxHeightRatio: 0.9,
                            context: context,
                            builder: (context) {
                              if (state is AuthLoggedState) {
                                return EditProfileView(
                                  user: state.user,
                                );
                              }
                              return Text("No User Data");
                            },
                          ),
                      icon: Icon(
                        Icons.edit_square,
                        color: blue,
                      ))
                ],
              ),
              body: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  if (state is RegisterLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoadingState) {
                        return Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (state is AuthLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is AuthLoggedState) {
                        final userData = state.user;
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildProfileItem(
                                    Icons.person, "Nama", userData.name ?? "-"),
                                Divider(),
                                _buildProfileItem(Icons.email, "Email",
                                    userData.email ?? "-"),
                                Divider(),
                                _buildProfileItem(Icons.location_on, "Alamat",
                                    userData.address ?? '-'),
                                Divider(),
                                _buildProfileItem(Icons.phone, "Telepon",
                                    userData.phoneNumber ?? '-'),
                                Divider(),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    myPurpleElevated(
                                      width: 170,
                                      onPress: () {
                                        showModalBottomSheet(
                                          clipBehavior: Clip.hardEdge,
                                          scrollControlDisabledMaxHeightRatio:
                                              0.9,
                                          context: context,
                                          builder: (context) {
                                            return ChangePasswordView();
                                          },
                                        );
                                      },
                                      text: "Ubah Password",
                                    ),
                                    myRedElevated(
                                      width: 170,
                                      onPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return MyAlertDialog(
                                                onConfirmText: "Keluar",
                                                onCancelColor: green,
                                                onConfirmColor: red,
                                                onConfirm: () {
                                                  context
                                                      .read<AuthBloc>()
                                                      .add(AuthLogoutEvent());
                                                  context
                                                      .read<BottomNavCubit>()
                                                      .updateIndex(0);
                                                },
                                                contentText:
                                                    "Anda yakin akan keluar?");
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
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                },
              ));
        },
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
