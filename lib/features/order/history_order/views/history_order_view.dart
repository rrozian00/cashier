import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Wajib tambah ini untuk format tanggal/waktu

import '../../../../core/utils/rupiah_converter.dart'; // Sesuaikan path utilitas rupiah Anda
import '../../../../core/widgets/no_data.dart';
import '../bloc/history_order_bloc.dart';
import 'widgets/history_header_widget.dart';

class HistoryOrderView extends StatelessWidget {
  const HistoryOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .grey.shade100, // Warna background agak abu agar struk putih menonjol
      appBar: const HistoryHeaderWidget(),
      body: BlocBuilder<HistoryOrderBloc, HistoryOrderState>(
        builder: (context, state) {
          if (state is HistoryOrderLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state is HistoryOrderFailed) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          }

          if (state is HistoryOrderLoaded && state.orders.isEmpty) {
            return noData(
              icon: CupertinoIcons.doc_text_search,
              title: "Riwayat Kosong",
              message: "Tidak ada transaksi di tanggal ini",
            );
          }

          if (state is HistoryOrderLoaded) {
            return ListView.builder(
              itemCount: state.orders.length,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemBuilder: (context, index) {
                final order = state.orders[index];

                // Format tanggal buatan struk (misal: 09 Juni 2026, 14:30)
                final String formattedDate = order.createdAt != null
                    ? DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt!)
                    : '-';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          4), // Struk biasanya tajam/sedikit membulat
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(75),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 HEADER STRUK (Header)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "NOTA: #${order.id?.toString().substring(0, 8).toUpperCase() ?? '-'}",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Gunakan font monospace agar mirip cetakan thermal
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Icon(Icons.print_rounded,
                                      size: 18, color: Colors.blue),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                order.name ?? "Pelanggan Anonim",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Garis putus-putus khas struk
                        const _DashedDivider(),

                        // 🔹 DAFTAR ITEM BELANJA (Content)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: (order.products != null &&
                                  order.products!.isNotEmpty)
                              ? Column(
                                  children: order.products!.map((item) {
                                    // Hitung subtotal per item (Harga x Qty)
                                    final int subtotalItem = (item.price ?? 0) *
                                        (item.quantity ?? 0);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Baris 1: Nama Produk
                                          Text(
                                            item.name ?? '-',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          // Baris 2: Detail Qty x Harga = Subtotal Item
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${item.quantity ?? 0} x ${rupiahConverter(item.price ?? 0)}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontFamily: 'Courier',
                                                ),
                                              ),
                                              Text(
                                                rupiahConverter(subtotalItem),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontFamily: 'Courier',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: Text(
                                    "Tidak ada detail produk",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ),
                        ),

                        const _DashedDivider(),

                        // 🔹 FOOTER STRUK (Total, Bayar, Kembali)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildFooterRow(
                                  "TOTAL", rupiahConverter(order.total ?? 0),
                                  isTotal: true),
                              const SizedBox(height: 8),
                              _buildFooterRow(
                                  "TUNAI", rupiahConverter(order.payment ?? 0)),
                              const SizedBox(height: 4),
                              _buildFooterRow("KEMBALI",
                                  rupiahConverter(order.change ?? 0)),
                              const SizedBox(height: 16),

                              // Ucapan terima kasih / Footer Struk
                              const Center(
                                child: Text(
                                  "*** TERIMA KASIH ***",
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Gagal memuat data"));
        },
      ),
    );
  }

  // Widget pembantu untuk baris footer (Total/Bayar/Kembali)
  Widget _buildFooterRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier', // Font thermal
            color: isTotal ? Colors.blue.shade700 : Colors.black,
          ),
        ),
      ],
    );
  }
}

// Widget khusus untuk membuat garis putus-putus khas struk belanja
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 5.0; // Lebar satu garis
          const dashHeight = 1.0; // Tinggi garis
          const dashGap = 3.0; // Jarak antar garis
          final dashCount = (boxWidth / (dashWidth + dashGap)).floor();

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey), // Warna garis
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
