import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/features/bottom_navigation_bar/cubit/bottom_nav_cubit.dart';
import 'package:cashier/features/home/views/home_view.dart';
import 'package:cashier/features/order/views/order_view.dart';
import 'package:cashier/features/printer/views/printer_view.dart';
import 'package:cashier/features/settings/views/settings_view.dart';
import 'package:cashier/features/store/views/store_view.dart';
import 'package:cashier/features/user/blocs/auth/auth_bloc.dart';
import 'package:cashier/features/user/views/profile_view.dart';

class BottomView extends StatelessWidget {
  const BottomView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthLoggedState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

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
                StoreView(),
                PrinterView(),
                ProfileView(),
              ];
        final tabs = role == 'owner'
            ? [
                GButton(icon: Icons.home, text: "Beranda"),
                GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
                GButton(icon: Icons.settings, text: "Pengaturan"),
              ]
            : [
                GButton(icon: Icons.home, text: "Beranda"),
                GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
                GButton(icon: Icons.store, text: "Store"),
                GButton(icon: Icons.print, text: "Printer"),
                GButton(icon: Icons.person, text: "Profil"),
              ];

        return BlocBuilder<BottomNavCubit, int>(
          builder: (context, selectedIndex) {
            return Scaffold(
              body: selectedIndex < pages.length
                  ? pages[selectedIndex]
                  : const Center(child: Text("Halaman tidak ditemukan")),
              bottomNavigationBar: GNav(
                // backgroundColor: softGrey,
                curve: Curves.bounceIn,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                padding: const EdgeInsets.only(
                    right: 10, left: 10, bottom: 35, top: 10),
                tabBorderRadius: 15,
                color: grey,
                activeColor: purple,
                tabs: tabs,
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  context.read<BottomNavCubit>().updateIndex(index);
                },
              ),
            );
          },
        );
      },
    );
  }
}
