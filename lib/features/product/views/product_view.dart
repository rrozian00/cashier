import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/core/widgets/my_alert_dialog.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/routes/app_pages.dart';

import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGrey,
      appBar: MyAppBar(
        titleText: "Produk",
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.listMenu.isEmpty) {
            return noData(
                title: "Menu Kosong", message: "Silahkan Tambah Menu");
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 20,
                  )),
              Expanded(
                flex: 50,
                child: ListView.builder(
                  itemCount: controller.listMenu.length,
                  itemBuilder: (context, index) {
                    final barang = controller.listMenu[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 3),
                      child: Card(
                        color: white,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: grey),
                        //   borderRadius: BorderRadius.circular(15),
                        // ),

                        elevation: 3, borderOnForeground: true,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: white),
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: barang.image != null &&
                                    barang.image!.isNotEmpty
                                ? ClipOval(
                                    // child: Image.file(
                                    //   File(barang.image!),
                                    //   height: 50,
                                    //   width: 50,
                                    //   fit: BoxFit.cover,
                                    //   errorBuilder:
                                    //       (context, error, stackTrace) {
                                    //     return Image.asset(
                                    //       'assets/icons/icon.png',
                                    //       fit: BoxFit.cover,
                                    //     );
                                    //   },
                                    // ),
                                    child: Image.network(barang.image ?? ''),
                                  )
                                : Image.asset(
                                    'assets/icons/icon.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          // leading: Text(
                          //   "${index + 1}",
                          //   style: GoogleFonts.roboto(
                          //       color: blue,
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          title: Text(
                            barang.name ?? '-',
                            style: GoogleFonts.poppins(
                              color: purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            rupiahConverter(
                              int.tryParse(barang.price ?? "") ?? 0,
                            ),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.dialog(MyAlertDialog(
                                    onConfirmText: "Hapus",
                                    contentText:
                                        "Apakah anda yakin akan menghapus data ini ?",
                                    onConfirm: () =>
                                        controller.deleteMenu(barang.id!),
                                  ));
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: red,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Get.toNamed(Routes.editMenus,
                                    arguments: {"data": barang}),
                                icon: Icon(
                                  Icons.edit,
                                  color: purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              myPurpleElevated(
                height: 45,
                width: 180,
                text: "Tambah Produk",
                onPress: () => Get.toNamed(Routes.addMenus),
              ),
            ],
          );
        }),
      ),
    );
  }
}
