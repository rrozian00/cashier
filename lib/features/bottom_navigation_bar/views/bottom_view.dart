import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:cashier/features/printer/controllers/printer_controller.dart';

import '../../home/views/home_view.dart';
import '../../order/order/views/order_view.dart';
import '../../printer/views/printer_view.dart';
import '../../settings/views/settings_view.dart';
import '../../store/views/store_view.dart';
import '../../user/blocs/auth/auth_bloc.dart';
import '../../user/views/profile_view.dart';
import '../cubit/bottom_nav_cubit.dart';

class BottomView extends StatelessWidget {
  const BottomView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PrinterController(), permanent: true);

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
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                curve: Curves.bounceIn,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                padding: const EdgeInsets.only(
                    right: 10, left: 10, bottom: 35, top: 10),
                tabBorderRadius: 15,
                color: Theme.of(context).disabledColor,
                activeColor: Theme.of(context).colorScheme.primary,
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
