import 'dart:io';

import 'package:cashier/utils/my_appbar.dart';
import 'package:cashier/utils/no_data.dart';
import 'package:cashier/utils/rupiah_converter.dart';
import 'package:flutter/material.dart';
import '../controllers/menuu_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuView extends GetView<MenuuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleText: "Daftar Menu",
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.listMenu.isEmpty) {
            return noData(
                title: "Menu Kosong", message: "Silahkan Tambah Menu");
          }

          return ListView.builder(
            itemCount: controller.listMenu.length,
            itemBuilder: (context, index) {
              final barang = controller.listMenu[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: barang.image != null && barang.image!.isNotEmpty
                          ? ClipOval(
                              child: Image.file(
                                File(barang.image!),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/icons/icon.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            )
                          : Image.asset(
                              'assets/icons/icon.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(
                      barang.name ?? '-',
                      style: GoogleFonts.poppins(
                        color: Colors.deepPurple,
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
                            controller.deleteDialog(barang.id!);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.editDialog(barang.id!);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(),
        ),
        child: TextButton(
          onPressed: () {
            controller.addDialog();
          },
          child: Text(
            "Tambah Menu",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
      ) // Tidak menampilkan tombol jika sudah ada menu
      ,
    );
  }
}
