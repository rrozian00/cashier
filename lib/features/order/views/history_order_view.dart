import '../../../core/theme/colors.dart';
import '../../../core/widgets/my_appbar.dart';
import '../../../core/widgets/my_elevated.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/utils/rupiah_converter.dart';
import '../models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../controllers/history_order_controller.dart';

class HistoryOrderView extends GetView<HistoryOrderController> {
  const HistoryOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: softGrey,
        appBar: MyAppBar(
          actions: [
            IconButton(
                onPressed: () {
                  controller.resetDateRangeAndData();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.deepPurple,
                ))
          ],
          title: myElevated(
            onPress: () async {
              await controller.pickDateRange(context);
            },
            child: Obx(() => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    controller.formattedDateRange.value != null
                        ? 'Tanggal: ${controller.formattedDateRange.value}'
                        : 'Pilih Tanggal',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                )),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.isTrue) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (controller.orderList.isEmpty) {
            return noData(
                icon: Icons.no_backpack_rounded,
                title: "Riwayat Kosong",
                message: "Silahkan pilih tanggal");
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tampilan total penjualan, gaji, keuntungan selama rentang tanggal yang dipilih
                  Obx(() {
                    return Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Penjualan',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text(
                              'Total Gaji Karyawan',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                            Text(
                              'Total Keuntungan',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text(
                              'Total Modal',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ': ${rupiahConverterDouble(controller.totalPenjualan.value)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text(
                              ': ${rupiahConverterDouble(controller.totalSalary.value)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                            Text(
                              ': ${rupiahConverterDouble(controller.totalProfit.value)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text(
                              ': ${rupiahConverterDouble(controller.totalExpense.value)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  // Menampilkan riwayat transaksi yang sudah difilter berdasarkan rentang tanggal
                  Expanded(
                    child: Obx(() {
                      final groupedTransactions = groupBy(
                        controller.orderList,
                        (OrderModel transaksi) {
                          // Mengelompokkan berdasarkan tanggal (tanpa jam-menit)
                          return DateFormat('dd-MM-yyyy HH:mm:ss')
                              .format(transaksi.createdAt!.toDate());
                        },
                      );

                      return ListView.builder(
                        itemCount: groupedTransactions.keys.length,
                        itemBuilder: (context, index) {
                          final createdAt = groupedTransactions.keys
                              .toList()
                              .reversed
                              .elementAt(index);
                          final transaksiGroup =
                              groupedTransactions[createdAt] ?? [];

                          final totalBayar = transaksiGroup.fold<int>(
                            0,
                            (sum, transaksi) =>
                                sum + int.tryParse(transaksi.total ?? '0')!,
                          );

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal: $createdAt",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Divider(),
                                  ...transaksiGroup.map((transaksi) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: transaksi.products
                                              ?.map((product) {
                                            final int price = int.tryParse(
                                                    product.price ?? '0') ??
                                                0;
                                            final int qty = int.tryParse(
                                                    product.quantity ?? '0') ??
                                                0;
                                            final int subtotal = price * qty;

                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Text("${product.name}"),
                                              subtitle: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text("Harga:"),
                                                      Text("Banyak:"),
                                                      Text("Subtotal:"),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(rupiahConverter(
                                                          price)),
                                                      Text("$qty pcs"),
                                                      Text(rupiahConverter(
                                                          subtotal)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList() ??
                                          [],
                                    );
                                  }),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "Total Harga:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Text("Bayar:"),
                                          Text("Kembalian:"),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rupiahConverter(totalBayar),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            rupiahConverter(
                                              int.tryParse(transaksiGroup
                                                          .first.payment ??
                                                      '0') ??
                                                  0,
                                            ),
                                          ),
                                          Text(
                                            rupiahConverter(
                                              int.tryParse(transaksiGroup
                                                          .first.refund ??
                                                      '0') ??
                                                  0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
