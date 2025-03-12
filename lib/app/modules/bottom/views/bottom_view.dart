import 'package:cashier/app/modules/bottom/controllers/bottom_controller.dart';
import 'package:cashier/app/modules/history_order/views/history_order_view.dart';
import 'package:cashier/app/modules/home/views/home_view.dart';
import 'package:cashier/app/modules/order/views/order_view.dart';
import 'package:cashier/app/modules/profile/views/profile_view.dart';
import 'package:cashier/app/modules/settings/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomView extends GetView<BottomController> {
  BottomView({super.key});
  final arg = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Widget> pages;
      if (controller.role.value == 'owner' || arg == 'owner') {
        pages = [
          HomeView(),
          TransaksiView(),
          HistoryOrderView(),
          SettingsView(),
        ];
      } else {
        pages = [
          TransaksiView(),
          // MenuView(),
          ProfileView(),
        ];
      }

      return Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: GNav(
          curve: Curves.bounceIn,
          // tabBorder: Border.all(),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 30),
          tabBorderRadius: 15,
          // backgroundColor: Colors.grey[100]!,
          color: Colors.grey[400],
          activeColor: Colors.deepPurple,
          tabs: controller.role.value == 'owner' || arg == 'owner'
              ? [
                  GButton(icon: Icons.home, text: "Beranda"),
                  GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
                  GButton(icon: Icons.notes_rounded, text: "Riwayat"),
                  GButton(icon: Icons.settings, text: "Pengaturan"),
                ]
              : [
                  GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
                  // GButton(icon: Icons.receipt, text: "Menu"),
                  GButton(icon: Icons.person, text: "Profil"),
                ],
          selectedIndex: controller.selectedIndex.value,
          onTabChange: (index) {
            controller.changeTab(index);
          },
        ),
      );
    });
  }
}
