import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../controllers/history_order_controller.dart';

class HistoryOrderView extends GetView<HistoryOrderController> {
  const HistoryOrderView({super.key});

  // Fungsi untuk menampilkan DateRangePicker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: controller.selectedDateRange.value,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != controller.selectedDateRange) {
      controller.selectedDateRange.value = picked;
      controller.formattedDateRange.value =
          '${DateFormat('dd/MM/yyyy').format(picked.start)} - ${DateFormat('dd/MM/yyyy').format(picked.end)}';

      controller.filterDataByDateRange(
        picked,
      );
      controller.filterDataByDateRange(
        picked,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPress: () {
              // controller.fetchExpense();
              _selectDateRange(context);
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
          if (controller.filteredOrderList.isEmpty) {
            return noData(
                title: "Riwayat Kosong", message: "Silahkan pilih tanggal");
          }
          return Padding(
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
                          // Text(
                          //   'Total Gaji Karyawan',
                          //   style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.amber),
                          // ),
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
                            ': ${rupiahConverterDouble(controller.filteredTotalPenjualan.value)}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          // Text(
                          //   ': ${rupiahConverterDouble(controller.filteredTotalSalary.value)}',
                          //   style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.amber),
                          // ),
                          Text(
                            ': ${rupiahConverterDouble(controller.filteredTotalProfit.value)}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Text(
                            ': ${rupiahConverterDouble(controller.filteredTotalExpense.value)}',
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
                      controller.filteredOrderList,
                      (transaksi) {
                        // Gunakan format yang menyertakan jam, menit, dan detik
                        return DateFormat('dd-MM-yyyy HH:mm')
                            .format(DateTime.parse(transaksi.createdAt!));
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
                          // margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal: $createdAt", // Menampilkan tanggal dengan format jam, menit, detik
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Divider(),
                                ...transaksiGroup.map((transaksi) {
                                  return ListTile(
                                    title: Text("${transaksi.name}"),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Harga:"),
                                            Text("Banyak:"),
                                            Text("Subtotal:"),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(rupiahConverter(int.tryParse(
                                                    transaksi.price ?? '') ??
                                                0)),
                                            Text("${transaksi.quantity} pcs"),
                                            Text(rupiahConverter(int.tryParse(
                                                    transaksi.total ?? '') ??
                                                0)),
                                          ],
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  );
                                }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Harga:",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
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
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(rupiahConverter(int.tryParse(
                                                transaksiGroup.first.payment ??
                                                    '') ??
                                            0)),
                                        Text(rupiahConverter(int.tryParse(
                                                transaksiGroup.first.refund ??
                                                    '') ??
                                            0)),
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
          );
        }));
  }
}
