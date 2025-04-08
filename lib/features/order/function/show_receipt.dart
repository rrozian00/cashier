import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/features/menu/models/product_model.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:cashier/features/order/function/print_receipt.dart';

class ShowReceipt extends GetView<OrderController> {
  const ShowReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 700,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Invoice
            Center(
              child: Column(
                children: [
                  Text(
                    "STRUK PEMBAYARAN",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${controller.storeData.value?.name} - ${controller.storeData.value?.address}",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Kasir: ${controller.userData.value?.name}",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1.5),

            // Daftar Produk
            Expanded(
              child: ListView(
                children: [
                  ...controller.cart.map((item) {
                    final produk = item['produk'] as ProductModel?;
                    if (produk == null) {
                      debugPrint("Produk null di item: $item");
                      return const SizedBox();
                    }

                    int hargaSatuan = int.tryParse(produk.price ?? '0') ?? 0;
                    int jumlah = item['jumlah'] ?? 0;
                    int subTotal = jumlah * hargaSatuan;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produk.name ?? 'Nama Tidak Ada',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "$jumlah x ${rupiahConverter(hargaSatuan)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            rupiahConverter(subTotal),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const Divider(thickness: 1.5),

            // Total Harga
            Column(
              children: [
                _buildRow("Subtotal", controller.totalHarga.value),
                _buildRow("Total Harga", controller.totalHarga.value,
                    bold: true),
                _buildRow("Bayar", controller.jumlahBayar.value),
                _buildRow("Kembalian", controller.kembalian.value, bold: true),
              ],
            ),

            const SizedBox(height: 20),

            // Tombol Tutup
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.displayText.value = '';
                      controller.cart.clear();
                      controller.jumlahBayar.value = 0;
                      controller.bayarController.clear();
                      controller.kembalian.value = 0;
                      Get.back(); // Menutup BottomSheet
                      Get.back(); // Menutup BottomSheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Tutup",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      printReceipt();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Print Struk",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Future<void> showReceipt() async {
//   final userData = await getUserData();
//   if (userData == null) return;

//   final store = await getStore();
//   if (store == null) return;

//   String storeName = store.name ?? '';
//   String address = store.address ?? '';
//   String kasir = userData.name ?? '';
//   debugPrint(
//       "Isi Keranjang sebelum tampilkan struk: ${keranjangBelanja.toList()}");

//   if (keranjangBelanja.isEmpty) {
//     Get.snackbar("Error", "Keranjang masih kosong!");
//     return;
//   }

//   Get.bottomSheet(
//     enableDrag: false,
//     isDismissible: false,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

//     isScrollControlled: true,
//   );
// }

// Fungsi untuk membuat baris total dengan tampilan lebih rapi
Widget _buildRow(String title, int value, {bool bold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          rupiahConverter(value),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
