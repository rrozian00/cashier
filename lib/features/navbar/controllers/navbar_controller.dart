import '../../home/views/home_view.dart';
import '../../order/views/order_view.dart';
import '../../setting/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavbarController extends GetxController {
  RxInt index = 0.obs;

  final pages = [
    HomeView(),
    OrderView(),
    // SettingsView(),
  ];

  final tabs = [
    GButton(icon: Icons.home, text: "Beranda"),
    GButton(icon: Icons.shopping_cart_rounded, text: "Keranjang"),
    // GButton(icon: Icons.settings, text: "Pengaturan"),
  ];
}
