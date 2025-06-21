import 'package:cashier/features/user/views/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/my_alert_dialog.dart';
import '../../navbar/cubit/bottom_nav_cubit.dart';
import '../blocs/auth/auth_bloc.dart';
import '../models/user_model.dart';
import 'change_password_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthCheckStatusEvent());
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginView(),
              ));
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
        appBar: AppBar(
          title: Text("Profil"),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoggedState) {
                  return IconButton(
                    icon: Icon(CupertinoIcons.pencil_ellipsis_rectangle),
                    onPressed: () => showModalBottomSheet(
                      showDragHandle: true,
                      clipBehavior: Clip.hardEdge,
                      scrollControlDisabledMaxHeightRatio: 0.9,
                      context: context,
                      builder: (context) => EditProfileView(user: state.user),
                    ),
                  );
                } else if (state is AuthLoggedState &&
                    state.verification == false) {
                  return Icon(Icons.edit);
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
              return _buildProfileBody(
                  context, user, state.verification, state.user.email ?? '');
            }

            return Center(child: Text("Gagal memuat state"));
          },
        ),
      ),
    );
  }

  Widget _buildProfileBody(
      BuildContext context, UserModel user, bool verification, String email) {
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
                      color: Colors.yellow,
                    ),
                    Text("Kirim link verifikasi ke email saya"),
                  ],
                ),
              ),
            ),
            _BuildProfileItem(
                icon: Icons.person, title: "Nama", value: user.name ?? "-"),
            Divider(),
            _BuildProfileItem(
                icon: Icons.email, title: "Email", value: user.email ?? "-"),
            Divider(),
            _BuildProfileItem(
                icon: Icons.location_on,
                title: "Alamat",
                value: user.address ?? "-"),
            Divider(),
            _BuildProfileItem(
                icon: Icons.phone,
                title: "Telepon",
                value: user.phoneNumber ?? "-"),
            Divider(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  // width: MediaQuery.of(context).size.width / 2.5,
                  onPressed: () {
                    showModalBottomSheet(
                      showDragHandle: true,
                      clipBehavior: Clip.hardEdge,
                      scrollControlDisabledMaxHeightRatio: 0.9,
                      context: context,
                      builder: (_) => ChangePasswordView(
                        email: email,
                      ),
                    );
                  },
                  child: Text("Ubah Password"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  // width: MediaQuery.of(context).size.width / 2.5,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MyAlertDialog(
                          onConfirmText: "Keluar",
                          onCancelColor: Colors.green,
                          onConfirmColor: Colors.red,
                          onConfirm: () {
                            context.read<AuthBloc>().add(AuthLogoutEvent());
                            context.read<BottomNavCubit>().updateIndex(0);
                          },
                          contentText: "Anda yakin akan keluar?",
                        );
                      },
                    );
                  },
                  child: Text("Keluar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk Item Profil
}

class _BuildProfileItem extends StatelessWidget {
  const _BuildProfileItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold)),
      subtitle: Text(value,
          key: ValueKey(value),
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
    );
  }
}
