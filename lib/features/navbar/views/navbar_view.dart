import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../home/views/home_view.dart';
import '../../order/order/views/order_view.dart';
import '../../printer/views/printer_view.dart';
import '../../setting/views/settings_view.dart';
import '../../user/profile/views/profile_view.dart';
import '../bloc/navbar_bloc.dart';

class NavbarView extends StatelessWidget {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (context, state) {
        if (state is NavbarLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state is NavbarSuccess) {
          final role = state.user.role;

          final pages = role == 'owner'
              ? [
                  HomeView(),
                  OrderView(),
                  SettingsView(),
                ]
              : [
                  HomeView(),
                  OrderView(),
                  PrinterView(),
                  ProfileView(),
                ];
          final tabs = (role == 'owner'
              ? [
                  GButton(icon: Icons.home, text: "Beranda"),
                  GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
                  GButton(icon: Icons.settings, text: "Pengaturan"),
                ]
              : [
                  GButton(icon: Icons.home, text: "Beranda"),
                  GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
                  GButton(icon: Icons.print, text: "Printer"),
                  GButton(icon: Icons.person, text: "Profil"),
                ]);
          return Scaffold(
            body: state.selectedIndex < pages.length
                ? pages[state.selectedIndex]
                : const Center(child: Text("Halaman tidak ditemukan")),
            bottomNavigationBar: GNav(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              curve: Curves.bounceIn,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              padding: const EdgeInsets.only(
                  right: 10, left: 10, bottom: 35, top: 10),
              tabBorderRadius: 15,
              color: Theme.of(context).disabledColor,
              activeColor: Theme.of(context).colorScheme.primary,
              tabs: tabs,
              selectedIndex: state.selectedIndex,
              onTabChange: (index) {
                context.read<NavbarBloc>().add(IndexChanged(index));
              },
            ),
          );
        }

        if (state is NavbarError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }
        return const Text("404");
      },
    );
  }
}
