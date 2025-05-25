import '../../order/views/history_order_view.dart';

import '../../product/bloc/product_bloc.dart';
import '../../user/blocs/employee/bloc/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';
import '../../../core/widgets/my_appbar.dart';
import '../../../routes/app_pages.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGrey,
      appBar: MyAppBar(
        titleText: 'Pengaturan',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView(
            children: [
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.profile);
                },
                title: "Profil",
                icon: Icons.person,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.store);
                },
                title: "Toko",
                icon: Icons.store,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.employee);
                  context.read<EmployeeBloc>().add(GetEmployeeRequested());
                },
                title: "Karyawan",
                icon: Icons.person_outline_rounded,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.product);
                  context.read<ProductBloc>().add(ProductGetRequested());
                },
                title: "Produk",
                icon: Icons.receipt_outlined,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.expense);
                },
                title: "Pengeluaran",
                icon: Icons.shopping_cart,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.printer);
                },
                title: "Printer",
                icon: Icons.print,
              ),
              _Listile(
                onPress: () {
                  Get.toNamed(Routes.inputManual);
                },
                title: "Input Manual",
                icon: Icons.checklist_rounded,
              ),
              _Listile(
                onPress: () {
                  // Get.toNamed(Routes.historyOrder);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryOrderView(),
                      ));
                },
                title: "Riwayat",
                icon: Icons.history_toggle_off_rounded,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Text(
        "v.2.0.0",
        style: TextStyle(color: oldGrey),
      ),
    );
  }
}

class _Listile extends StatelessWidget {
  final VoidCallback? onPress;
  final String? title;
  final IconData? icon;

  const _Listile({
    this.onPress,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        left: 10.0,
        right: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: white,
            // border: Border.all(color: grey),
            borderRadius: BorderRadius.circular(15)),
        // color: Colors.black,
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          trailing: Icon(
            color: grey,
            Icons.navigate_next_rounded,
            size: 35,
          ),
          onTap: onPress,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading: CircleAvatar(
            backgroundColor: purple.withAlpha(50),
            child: Icon(
              icon,
              color: purple,
            ),
          ),
          title: Text(
            title ?? "-",
            style: GoogleFonts.jetBrainsMono(color: black),
          ),
        ),
      ),
    );
  }
}
