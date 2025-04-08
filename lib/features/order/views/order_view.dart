import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/core/utils/scanner_page.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/menu/models/product_model.dart';
import 'package:cashier/routes/app_pages.dart';

import '../controllers/order_controller.dart';

class TransaksiView extends GetView<OrderController> {
  const TransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleText: 'Pilih Menu',
        leading: IconButton(
          color: Colors.deepPurple,
          onPressed: () {
            controller.fetchProduct();
            Get.snackbar("Sukses", "Berhasil Update Menu");
          },
          icon: const Icon(Icons.refresh),
        ),
      ),
      body: Column(
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
                      Text("Keranjang Kosong,",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500)),
                      Text("Silahkan pilih Menu !",
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

                  return Card(
                    elevation: 4,
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/icon.png',
                        color: Colors.black,
                      ),
                      title: Text(
                        produk.name ?? 'Nama Produk',
                        style: GoogleFonts.poppins(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${rupiahConverter(int.tryParse(produk.price ?? '') ?? 0)} x $jumlah pcs',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_rounded,
                                color: Colors.black),
                            onPressed: () =>
                                controller.hapusDariKeranjang(produk),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_rounded,
                                color: Colors.black),
                            onPressed: () =>
                                controller.tambahKeKeranjang(produk),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controller.totalHarga.value != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total"),
                            Text(rupiahConverter(controller.totalHarga.value),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: purple,
                                    fontSize: 24)),
                          ],
                        )
                      : Container(),
                  controller.cart.isNotEmpty
                      ? myPurpleElevated(
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
                horizontal: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  myPurpleElevated(
                      text: "Produk List",
                      onPress: () => Get.toNamed(Routes.productList)),
                  myPurpleElevated(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Scan Barcode",
                          style: GoogleFonts.poppins(color: Colors.white),
                        )
                      ],
                    ),
                    onPress: () async {
                      final result = await Get.to(ScannerPage());
                      if (result != null) {
                        controller.scannedBarcode.value =
                            result; // Simpan hasil scan untuk order
                        if (result != "-1") {
                          controller.scannedBarcode.value = result;
                          controller.tambahKeKeranjangByBarcode(result);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
