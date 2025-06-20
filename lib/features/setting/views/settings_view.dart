import 'package:cashier/features/printer/views/printer_view.dart';
import 'package:cashier/features/setting/cubit/version_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_theme/theme_cubit/theme_cubit.dart';
import '../../../routes/app_pages.dart';
import '../../order/history_order/bloc/history_order_bloc.dart';
import '../../order/history_order/views/history_order_view.dart';
import '../../product/blocs/product_bloc/product_bloc.dart';
import '../../store/bloc/store_bloc.dart';
import '../../user/blocs/employee/bloc/employee_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Pengaturan'),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _SettingListile(
                    onPress: () {
                      Get.toNamed(Routes.profile);
                    },
                    title: "Profil",
                    icon: Icons.person,
                  ),
                  _SettingListile(
                    onPress: () {
                      Get.toNamed(Routes.store);
                      context.read<StoreBloc>().add(GetStoresList());
                    },
                    title: "Toko",
                    icon: Icons.store,
                  ),
                  _SettingListile(
                    onPress: () {
                      Get.toNamed(Routes.employee);
                      context.read<EmployeeBloc>().add(GetEmployeeRequested());
                    },
                    title: "Karyawan",
                    icon: Icons.person_outline_rounded,
                  ),
                  _SettingListile(
                    onPress: () {
                      Get.toNamed(Routes.product);
                      context.read<ProductBloc>().add(ProductGetRequested());
                    },
                    title: "Produk",
                    icon: Icons.receipt_outlined,
                  ),
                  _SettingListile(
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
                  _SettingListile(
                    onPress: () {
                      // Get.toNamed(Routes.printer);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrinterView(),
                          ));
                    },
                    title: "Printer",
                    icon: Icons.print,
                  ),
                  _SettingListile(
                    onPress: () {
                      Get.toNamed(Routes.inputManual);
                    },
                    title: "Input Manual",
                    icon: Icons.checklist_rounded,
                  ),
                  _SettingListile(
                    onPress: () {
                      Get.toNamed(Routes.expense);
                    },
                    title: "Pengeluaran",
                    icon: Icons.shopping_cart,
                  ),
                  _SettingListile(
                    onPress: () {
                      _showThemeDialog(context);
                    },
                    title: "Tema",
                    icon: Icons.palette_outlined,
                  ),
                ],
              ),
            ),
            BlocBuilder<VersionCubit, String>(
              builder: (context, state) {
                return Text(
                  state,
                  style: TextStyle(color: Theme.of(context).disabledColor),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _showThemeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Simpan"))
        ],
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Column(
          spacing: 35,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pilih Tema",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.read<ThemeCubit>().chooseTheme(true);
                    },
                    child: Text("Gelap")),
                ElevatedButton(
                    onPressed: () {
                      context.read<ThemeCubit>().chooseTheme(false);
                    },
                    child: Text("Terang")),
              ],
            ),
            // TextButton(
            //     onPressed: () => Navigator.pop(context), child: Text("Simpan"))
          ],
        ),
      );
    },
  );
}

class _SettingListile extends StatelessWidget {
  final VoidCallback? onPress;
  final String? title;
  final IconData? icon;

  const _SettingListile({
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
            // boxShadow: [
            //   BoxShadow(
            //       color: Theme.of(context).colorScheme.secondary,
            //       blurStyle: BlurStyle.outer,
            //       spreadRadius: 1,
            //       blurRadius: 1,
            //       offset: Offset(0, 1))
            // ],
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          trailing: Icon(
            color: Colors.grey,
            Icons.navigate_next_rounded,
            size: 35,
          ),
          onTap: onPress,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
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
