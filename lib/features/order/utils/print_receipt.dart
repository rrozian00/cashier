import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/features/product/models/product_model.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';

Future<void> printReceipt() async {
  final controller = Get.find<OrderController>();

  final storeName = controller.storeData.value?.name;
  final storeAddress = controller.storeData.value?.address;

  bool isConnected = await PrintBluetoothThermal.connectionStatus;
  if (!isConnected) {
    debugPrint("Printer belum terhubung!");
    Get.snackbar("Error", "Belum ada printer yang Terhubung!");
    return;
  }

  // Konfigurasi printer ESC/POS
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  List<int> bytes = [];

  // **1. Header Struk**
  bytes += generator.text(
    storeName ?? '',
    styles: PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
      bold: true,
    ),
  );
  bytes += generator.text(storeAddress ?? '',
      styles: PosStyles(align: PosAlign.center));
  bytes += generator.text("--------------------------------");

  // **2. Informasi Transaksi**
  final kasir = controller.userData.value?.name;
  final today = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
  bytes += generator.text("Tanggal: $today",
      styles: PosStyles(align: PosAlign.left));
  bytes += generator.text("Kasir  : $kasir",
      styles: PosStyles(align: PosAlign.left));
  bytes += generator.text("--------------------------------");

  // **3. Header Daftar Produk**
  bytes += generator.text(
    "Produk / Qty x Harga   Subtotal",
    styles: PosStyles(bold: true),
  );
  bytes += generator.text("--------------------------------");

  // **4. Daftar Produk**
  debugPrint(
      "Isi Keranjang: ${controller.cart.map((e) => e.toString()).toList()}");

  if (controller.cart.isEmpty) {
    debugPrint("Tidak ada item dalam keranjang!");
    Get.snackbar("Error", "Keranjang masih kosong!");
    return;
  }

  for (var item in controller.cart) {
    final produk = item['produk'] as ProductModel?;
    if (produk == null) continue;

    int hargaSatuan = int.tryParse(produk.price ?? '0') ?? 0;
    int jumlah = item['jumlah'] ?? 0;
    int subTotal = jumlah * hargaSatuan;

    // Format produk dengan rata kiri untuk nama & rata kanan untuk angka
    bytes += generator.row([
      PosColumn(
          text: produk.name ?? '-',
          width: 12,
          styles: PosStyles(align: PosAlign.left)),
      // PosColumn(
      //     text: "$jumlah x",
      //     width: 2,
      //     styles: PosStyles(align: PosAlign.right)),
      // PosColumn(
      //     text: rupiahConverter(hargaSatuan),
      //     width: 6,
      //     styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: "$jumlah x ${rupiahConverter(hargaSatuan)}",
          width: 6,
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: rupiahConverter(subTotal),
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]);
  }

  bytes += generator.text("--------------------------------");

  // **5. Total Harga, Bayar, dan Kembalian**
  bytes += generator.row([
    PosColumn(
        text: "Total :",
        width: 8,
        styles: PosStyles(align: PosAlign.right, bold: true)),
    PosColumn(
        text: rupiahConverter(controller.totalHarga.value),
        width: 4,
        styles: PosStyles(align: PosAlign.right, bold: true)),
  ]);
  bytes += generator.row([
    PosColumn(
        text: "Bayar :", width: 8, styles: PosStyles(align: PosAlign.right)),
    PosColumn(
        text: rupiahConverter(controller.jumlahBayar.value),
        width: 4,
        styles: PosStyles(align: PosAlign.right)),
  ]);
  bytes += generator.row([
    PosColumn(
        text: "Kembali :",
        width: 8,
        styles: PosStyles(align: PosAlign.right, bold: true)),
    PosColumn(
        text: rupiahConverter(controller.kembalian.value),
        width: 4,
        styles: PosStyles(align: PosAlign.right, bold: true)),
  ]);

  bytes += generator.text("--------------------------------");

  // **6. Footer Struk**
  bytes += generator.text("Terima Kasih!",
      styles: PosStyles(align: PosAlign.center, bold: true));
  bytes += generator.text("Silahkan datang kembali",
      styles: PosStyles(align: PosAlign.center));
  bytes += generator.cut(); // Potong kertas setelah cetak selesai

  // **7. Kirim data ke printer**
  final result = await PrintBluetoothThermal.writeBytes(bytes);
  if (result) {
    debugPrint("Cetak berhasil!");
    debugPrint("Data yang dikirim ke printer: $bytes");
  } else {
    debugPrint("Cetak gagal!");
  }
}
