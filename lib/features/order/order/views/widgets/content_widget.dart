import '../../../../../core/utils/rupiah_converter.dart';
import '../../models/order_model.dart';
import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    super.key,
    required this.groupedTransactions,
  });

  final Map<String, List<OrderModel>> groupedTransactions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tampilan total penjualan, gaji, keuntungan selama rentang tanggal yang dipilih
            // Obx(() {
            //   return Row(
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Total Penjualan',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.blue),
            //           ),
            //           Text(
            //             'Total Gaji Karyawan',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.amber),
            //           ),
            //           Text(
            //             'Total Keuntungan',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.green),
            //           ),
            //           Text(
            //             'Total Modal',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.red),
            //           ),
            //         ],
            //       ),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             ': ${rupiahConverterDouble(controller.totalPenjualan.value)}',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.blue),
            //           ),
            //           Text(
            //             ': ${rupiahConverterDouble(controller.totalSalary.value)}',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.amber),
            //           ),
            //           Text(
            //             ': ${rupiahConverterDouble(controller.totalProfit.value)}',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.green),
            //           ),
            //           Text(
            //             ': ${rupiahConverterDouble(controller.totalExpense.value)}',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.red),
            //           ),
            //         ],
            //       ),
            //     ],
            //   );
            // }),
            // Menampilkan riwayat transaksi yang sudah difilter berdasarkan rentang tanggal
            Expanded(
              child: ListView.builder(
                itemCount: groupedTransactions.keys.length,
                itemBuilder: (context, index) {
                  final createdAt = groupedTransactions.keys
                      .toList()
                      .reversed
                      .elementAt(index);
                  final transaksiGroup = groupedTransactions[createdAt] ?? [];

                  final totalBayar = transaksiGroup.fold<int>(
                    0,
                    (sum, transaksi) =>
                        sum + int.tryParse(transaksi.total ?? '0')!,
                  );

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: transaksi.products?.map((product) {
                                    final int price = int.tryParse(
                                            product.product.price ?? '0') ??
                                        0;
                                    final int qty =
                                        product.product.quantity ?? 0;
                                    final int subtotal = price * qty;

                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text("${product.product.name}"),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text("Harga:"),
                                              Text("Banyak:"),
                                              Text("Subtotal:"),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(rupiahConverter(price)),
                                              Text("$qty pcs"),
                                              Text(rupiahConverter(subtotal)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rupiahConverter(totalBayar),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    rupiahConverter(
                                      int.tryParse(
                                              transaksiGroup.first.payment ??
                                                  '0') ??
                                          0,
                                    ),
                                  ),
                                  Text(
                                    rupiahConverter(
                                      int.tryParse(
                                              transaksiGroup.first.refund ??
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
