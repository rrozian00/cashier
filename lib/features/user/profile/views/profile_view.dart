import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/my_alert_dialog.dart';
import '../../login/views/login_view.dart';
import '../../models/user_model.dart';
import '../blocs/profile_bloc/profile_bloc.dart';
import 'change_password_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogout) {
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Profil"), actions: [
            
          ]
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if (state is ProfileError) {
              return Center(child: Text(state.message));
            }

            if (state is ProfileSuccess) {
              final user = state.user;
              return _buildProfileBody(
                  context, user, true, state.user.email ?? '');
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
                  context.read<ProfileBloc>().add(VerificationSent());
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
            Center(
              child: Column(
                spacing: 10,
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
                      onPressed: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          clipBehavior: Clip.hardEdge,
                          scrollControlDisabledMaxHeightRatio: 0.9,
                          context: context,
                          builder: (_) => EditProfileView(user: user),
                        );
                      },
                      child: Text("Edit Profil")),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return MyAlertDialog(
                            onConfirmText: "Keluar",
                            onCancelColor: Colors.green,
                            onConfirmColor: Colors.red,
                            onConfirm: () {
                              context
                                  .read<ProfileBloc>()
                                  .add(LogoutSubmitted());
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget untuk Item Profil
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
