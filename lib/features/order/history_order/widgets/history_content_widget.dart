import '../../../../core/utils/rupiah_converter.dart';
import '../../order/models/order_model.dart';
import 'package:flutter/material.dart';

class HistoryContentWidget extends StatelessWidget {
  const HistoryContentWidget({
    super.key,
    required this.groupedTransactions,
  });

  final Map<String, List<OrderModel>> groupedTransactions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daftar transaksi per tanggal (dari yang terbaru)
          Expanded(
            child: ListView.builder(
              itemCount: groupedTransactions.keys.length,
              itemBuilder: (context, index) {
                final createdAt =
                    groupedTransactions.keys.toList().reversed.elementAt(index);
                final transaksiGroup = groupedTransactions[createdAt] ?? [];

                final totalBayar = transaksiGroup.fold<int>(
                  0,
                  (sum, transaksi) =>
                      sum + int.tryParse(transaksi.total ?? '0')!,
                );

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tanggal Transaksi
                        Text(
                          "Tanggal: $createdAt",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),

                        // Daftar Produk dalam tiap transaksi
                        ...transaksiGroup.map((transaksi) {
                          final productWidgets =
                              transaksi.products?.map((product) {
                            final int price =
                                int.tryParse(product.product.price ?? '0') ?? 0;
                            final int qty = product.product.quantity ?? 0;
                            final int subtotal = price * qty;

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(product.product.name ?? '-'),
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
                          }).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: productWidgets ?? [],
                          );
                        }),

                        const Divider(),

                        // Ringkasan pembayaran
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
                                    fontSize: 16,
                                  ),
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
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  rupiahConverter(
                                    int.tryParse(
                                          transaksiGroup.first.payment ?? '0',
                                        ) ??
                                        0,
                                  ),
                                ),
                                Text(
                                  rupiahConverter(
                                    int.tryParse(
                                          transaksiGroup.first.refund ?? '0',
                                        ) ??
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
    );
  }
}
