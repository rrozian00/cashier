import 'package:cashier/core/theme/cubit/theme_cubit.dart';
import 'package:cashier/features/order/blocs/history_order_bloc/history_order_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../order/views/history_order_view.dart';

import '../../product/bloc/product_bloc.dart';
import '../../user/blocs/employee/bloc/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(Icons.palette_outlined)),
        title: Text('Pengaturan'),
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
                  context
                      .read<HistoryOrderBloc>()
                      .add(ShowInitial(context: context));
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
        top: 10,
        left: 10.0,
        right: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.secondary,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1))
            ],
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(15)),
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
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          title: Text(
            title ?? "-",
            style: GoogleFonts.jetBrainsMono(),
          ),
        ),
      ),
    );
  }
}
