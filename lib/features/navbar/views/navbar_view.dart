import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../controllers/navbar_controller.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: controller.index < controller.pages.length
              ? controller.pages[controller.index.value]
              : const Center(child: Text("Halaman tidak ditemukan")),
          bottomNavigationBar: GNav(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            curve: Curves.bounceIn,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            padding:
                const EdgeInsets.only(right: 10, left: 10, bottom: 35, top: 10),
            tabBorderRadius: 15,
            color: Theme.of(context).disabledColor,
            activeColor: Theme.of(context).colorScheme.primary,
            tabs: controller.tabs,
            selectedIndex: controller.index.value,
            onTabChange: (index) {
              controller.index.value = index;
            },
          ),
        ));
  }
}
