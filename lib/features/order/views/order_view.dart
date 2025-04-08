import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/core/utils/scanner_page.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/menu/models/product_model.dart';

import '../controllers/order_controller.dart';

class TransaksiView extends GetView<OrderController> {
  const TransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    // final HomeController home = Get.find<HomeController>();
    return Scaffold(
      appBar: MyAppBar(
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0),
        //     child: Obx(() => Text(
        //           "-${home.storeNameFinal.value}-",
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 16,
        //               color: Colors.deepPurple),
        //         )),
        //   ),
        // ],
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
            flex: 10,
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
                          onPress: () => Get.to(() => CheckOutView()),
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

class CheckOutView extends GetView<OrderController> {
  const CheckOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // actions: [
        //   SizedBox()
        // ],
        title: Obx(() {
          return Container(
              height: 50,
              width: 280,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                  child: Text(
                "TOTAL:   ${rupiahConverter(controller.totalHarga.value)}",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )));
        }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Masukkan Jumlah Bayar",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
              // Layar tampilan angka
              Container(
                height: 150,
                width: double.infinity,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        rupiahConverter(
                            int.tryParse(controller.displayText.value) ?? 0),
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    )),
              ),
              SizedBox(height: 10),

              // Tombol angka
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    List<String> buttons = [
                      '7',
                      '8',
                      '9',
                      '4',
                      '5',
                      '6',
                      '1',
                      '2',
                      '3',
                      '0',
                      '000',
                      'C'
                    ];

                    return myElevated(
                      onPress: () {
                        if (buttons[index] == 'C') {
                          controller.clearTap();
                        }
                        // else if (buttons[index] == 'OK') {
                        //   controller.insertTransaksi();
                        // }
                        else {
                          controller.onNumberPressed(buttons[index]);
                        }
                      },
                      child: Center(
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => controller.jumlahBayar.value != 0 &&
                controller.jumlahBayar.value >= controller.totalHarga.value
            ? myElevated(
                child: Text("PROSES",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                onPress: () => controller.insertTransaksi(),
              )
            : Text("Jumlah Pembayaran Kurang",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
