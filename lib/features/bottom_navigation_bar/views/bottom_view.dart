import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/features/bottom_navigation_bar/controllers/bottom_controller.dart';
import 'package:cashier/features/home/views/home_view.dart';
import 'package:cashier/features/order/views/order_view.dart';
import 'package:cashier/features/printer/views/printer_view.dart';
import 'package:cashier/features/user/views/profile_view.dart';
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
          PrinterView(),
          ProfileView(),
        ];
      } else {
        pages = [
          TransaksiView(),
          PrinterView(),
          ProfileView(),
        ];
      }

      return Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: GNav(
          curve: Curves.bounceIn,
          // tabBorder: Border.all(),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          padding:
              const EdgeInsets.only(right: 10, left: 10, bottom: 35, top: 10),
          tabBorderRadius: 15,
          // backgroundColor: Colors.grey[100]!,
          color: grey,
          activeColor: purple,
          tabs: controller.role.value == 'owner' || arg == 'owner'
              ? [
                  GButton(icon: Icons.home, text: "Beranda"),
                  GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
                  GButton(icon: Icons.print, text: "Printer"),
                  GButton(icon: Icons.person, text: "Profil"),
                ]
              : [
                  GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
                  GButton(icon: Icons.print, text: "Printer"),
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
