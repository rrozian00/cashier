// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cashier/features/order/blocs/order_bloc/order_bloc.dart';
import 'package:cashier/features/order/check_out/bloc/check_out_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../../product/models/product_model.dart';
import 'print_receipt.dart';

class ShowReceipt extends StatelessWidget {
  const ShowReceipt({
    super.key,
    required this.storeName,
    required this.storeAddress,
    required this.userName,
    required this.state,
    required this.orderBloc,
  });

  final String storeName;
  final String storeAddress;
  final String userName;

  final CheckOutState state;
  final OrderBloc orderBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Invoice
            Center(
              child: Column(
                children: [
                  Text(
                    "STRUK PEMBAYARAN",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$storeName - $storeAddress",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "Kasir: $userName",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1.5),

            // Daftar Produk
            Expanded(
              child: ListView(
                children: [
                  ...orderBloc.cart.map((item) {
                    final produk = item.product as ProductModel?;
                    if (produk == null) {
                      debugPrint("Produk null di item: $item");
                      return const SizedBox();
                    }

                    int hargaSatuan = int.tryParse(produk.price ?? '0') ?? 0;
                    int jumlah = item.quantity;
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "$jumlah x ${rupiahConverter(hargaSatuan)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            rupiahConverter(subTotal),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
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
                _buildRow("Total Harga", state.totalPrice, bold: true),
                _buildRow("Bayar", state.paymentAmount),
                _buildRow("Kembalian", (state.paymentAmount - state.totalPrice),
                    bold: true),
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
                      context.read<CheckOutBloc>().add(ClearReceipt());
                      context.read<OrderBloc>().add(ClearCart());
                      Navigator.pop(context);
                      Navigator.pop(context);
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
                          fontSize: 12, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      printReceipt(
                        cart: orderBloc.cart,
                        state: state,
                        storeAddress: storeAddress,
                        storeName: storeName,
                        userName: userName,
                      );
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
                          fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40)
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
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          rupiahConverter(value),
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
