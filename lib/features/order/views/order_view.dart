import 'package:cashier/features/product/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/core/utils/scanner_page.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/product/models/product_model.dart';
import 'package:cashier/features/product/views/product_list.dart';
import 'package:cashier/routes/app_pages.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController()); //TODO:

    return Scaffold(
      backgroundColor: softGrey,
      appBar: MyAppBar(titleText: 'Pilih Produk', actions: [
        IconButton(
          color: blue,
          onPressed: () => controller.clearCart(),
          icon: Icon(
            Icons.clear,
            color: red,
          ),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Keranjang Belanja
              Expanded(
                flex: 4,
                child: Obx(() {
                  if (controller.cart.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty.png',
                            height: 70,
                          ),
                          Text("Keranjang Kosong",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w500)),
                          Text("Silahkan pilih Daftar Produk / Scan Barcode",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.cart.length,
                    itemBuilder: (context, index) {
                      final item = controller.cart[index];
                      final produk = item['produk'] as ProductModel;
                      final jumlah = item['jumlah'] as int;

                      return Dismissible(
                        confirmDismiss: (direction) async {
                          return await Get.dialog(
                            Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Konfirmasi',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: purple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 30),
                                    const Text(
                                      'Yakin ingin menghapus produk ini dari keranjang?',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        myGreenElevated(
                                          width: 120,
                                          onPress: () =>
                                              Get.back(result: false),
                                          text: 'Batal',
                                        ),
                                        myRedElevated(
                                          width: 120,
                                          onPress: () => Get.back(result: true),
                                          text: 'Hapus',
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        key: Key(produk.id ?? UniqueKey().toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          controller.deleteCart(
                              produk); // ganti sesuai fungsi hapusmu
                        },
                        child: Card(
                          elevation: 4,
                          color: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              ListTile(
                                onTap: () =>
                                    controller.addValueCart(produk, jumlah),
                                leading: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(produk.image ?? ""),
                                ),
                                title: Text(
                                  produk.name ?? 'Nama Produk',
                                  style: GoogleFonts.poppins(
                                      color: purple,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  rupiahConverter(
                                      int.tryParse(produk.price ?? '') ?? 0),
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_rounded,
                                          color: red),
                                      onPressed: () =>
                                          controller.removeCart(produk),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.add_rounded, color: green),
                                      onPressed: () =>
                                          controller.addCart(produk),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  top: 6,
                                  left: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.pink,
                                    ),
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: Text(
                                        jumlah.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.totalHarga.value != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total"),
                                Text(
                                    rupiahConverter(
                                        controller.totalHarga.value),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: purple,
                                        fontSize: 24)),
                              ],
                            )
                          : Container(),
                      controller.cart.isNotEmpty
                          ? myGreenElevated(
                              width: 150,
                              onPress: () => Get.toNamed(Routes.checkOut),
                              child: Text(
                                "BAYAR",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ))
                          : Container()
                    ],
                  );
                }),
              ),
              Divider(),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      myPurpleIconElevated(
                          icon: Icons.list,
                          text: "Daftar Produk",
                          onPress: () {
                            Get.bottomSheet(
                              clipBehavior: Clip.hardEdge,
                              ProductList(),
                            );
                            context
                                .read<ProductBloc>()
                                .add(ProductGetRequested());
                          }),
                      myPurpleIconElevated(
                          onPress: () async {
                            final result = await Get.to(ScannerPage());

                            if (result != null) {
                              controller.scannedBarcode.value = result;
                              if (result != "-1") {
                                controller.scannedBarcode.value = result;
                                controller.addCartByBarcode(result);
                              }
                            }
                          },
                          text: "Scan Barcode",
                          icon: Icons.qr_code_scanner_rounded)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
