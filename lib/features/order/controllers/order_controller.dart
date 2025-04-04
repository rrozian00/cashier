import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:cashier/features/order/order_model.dart';
import 'package:cashier/features/home/controllers/home_controller.dart';
import 'package:cashier/features/menu/models/menu_model.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';

class OrderController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final HomeController homeController = Get.find();

  var displayText = ''.obs;

  final scannedBarcode = ''.obs;

  void tambahKeKeranjangByBarcode(String barcode) {
    // Cari produk berdasarkan barcode
    var item = produk.firstWhereOrNull((menu) => menu.barcode == barcode);

    if (item != null) {
      tambahKeKeranjang(item);
    } else {
      Get.snackbar("Error", "Produk tidak ditemukan");
    }
  }

  void onNumberPressed(String number) {
    // Tambahkan angka baru ke displayText
    displayText.value += number;

    // Hilangkan titik sebelum parsing agar tidak error
    String cleanedNumber = displayText.value.replaceAll('.', '');

    // Konversi ke integer
    jumlahBayar.value = int.tryParse(cleanedNumber) ?? 0;

    // Format ulang dengan titik ribuan
    String formattedText =
        NumberFormat("#,###", "id_ID").format(jumlahBayar.value);

    // Update TextEditingController dengan format yang benar
    bayarController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
          offset: formattedText.length), // Pastikan kursor tetap di akhir teks
    );

    // Memastikan UI diperbarui
    update();
  }

  void onClear() {
    displayText.value = '';
    jumlahBayar.value = 0;
  }

  Rxn<User> firebaseUser = Rxn<User>();
  var storeId = "".obs;
  var isOwner = false.obs;
  var isEmployee = false.obs;

  final produk = <MenuModel>[].obs;
  final keranjangBelanja = <Map<String, dynamic>>[].obs;

  var totalHarga = 0.obs;
  var jumlahBayar = 0.obs;
  var kembalian = 0.obs;

  final userName = ''.obs;

  var selectedProduk = Rxn<MenuModel>(); // Kembalikan selectedProduk
  TextEditingController bayarController =
      TextEditingController(); // Kembalikan bayarController

  void getUser() async {
    final userId = _auth.currentUser!.uid;
    var snapshot = await _firestore.collection('users').doc(userId).get();
    userName.value = snapshot.data()?['name'];
  }

  void clearUserData() {
    storeId.value = "";
    isOwner.value = false;
    isEmployee.value = false;
  }

  Future<void> fetchUserStore(String uid) async {
    try {
      final storeQuery = await _firestore
          .collection('stores')
          .where('ownerId', isEqualTo: uid)
          .get();

      if (storeQuery.docs.isNotEmpty) {
        storeId.value = storeQuery.docs.first.id;
        isOwner.value = true;
        isEmployee.value = false;
        fetchProduk();
        return;
      }

      final storeDocs = await _firestore.collection('stores').get();
      for (var store in storeDocs.docs) {
        List<dynamic> employeeIds = store.data()['employees'] ?? [];
        if (employeeIds.contains(uid)) {
          storeId.value = store.id;
          isEmployee.value = true;
          isOwner.value = false;
          fetchProduk();
          return;
        }
      }

      storeId.value = "";
      isOwner.value = false;
      isEmployee.value = false;
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data store: $e");
    }
  }

  Future<void> fetchProduk() async {
    produk.clear();
    if (storeId.value.isEmpty) return;

    try {
      final snapshot = await _firestore
          .collection('stores')
          .doc(storeId.value)
          .collection('menus')
          .get();

      produk.assignAll(
          snapshot.docs.map((doc) => MenuModel.fromMap(doc.data())).toList());
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data produk: $e");
    }
  }

  void tambahKeKeranjang(MenuModel item) {
    bool sudahAda = keranjangBelanja.any((el) => el['produk'] == item);
    if (sudahAda) {
      for (var el in keranjangBelanja) {
        if (el['produk'] == item) {
          el['jumlah']++;
        }
      }
    } else {
      keranjangBelanja.add({'produk': item, 'jumlah': 1});
    }

    keranjangBelanja.refresh(); // Tambahkan ini agar UI diperbarui
    hitungTotal();
  }

  void hapusDariKeranjang(MenuModel item) {
    for (var el in keranjangBelanja) {
      if (el['produk'] == item) {
        if (el['jumlah'] > 1) {
          el['jumlah']--;
        } else {
          keranjangBelanja.remove(el);
        }
        break;
      }
    }
    keranjangBelanja.refresh(); // Tambahkan ini agar UI diperbarui
    hitungTotal();
  }

  void hitungTotal() {
    int total = 0;
    for (var item in keranjangBelanja) {
      final produk = item['produk'] as MenuModel;
      final jumlah = item['jumlah'] as int;
      total += (int.tryParse(produk.price ?? '0') ?? 0) * jumlah;
    }
    totalHarga.value = total;

    // Pastikan kembalian diperbarui secara real-time
    kembalian.value = (jumlahBayar.value >= totalHarga.value)
        ? jumlahBayar.value - totalHarga.value
        : 0;
  }

  void insertTransaksi() async {
    if (jumlahBayar.value < totalHarga.value) {
      Get.snackbar("Error!", "Jumlah Bayar Kurang");
      return;
    }

    final createdAt = DateTime.now().toIso8601String();

    for (var item in keranjangBelanja) {
      final produk = item['produk'] as MenuModel;
      final jumlah = item['jumlah'] as int;
      final totalHargaProduk = int.tryParse(produk.price ?? '0')! * jumlah;

      final model = OrderModel(
        name: produk.name,
        quantity: jumlah.toString(),
        price: produk.price,
        total: totalHargaProduk.toString(),
        payment: jumlahBayar.value.toString(),
        refund: kembalian.value.toString(),
        createdAt: createdAt,
      );

      try {
        await _firestore
            .collection('stores')
            .doc(storeId.value)
            .collection('orders')
            .add(model.toJson());
      } catch (e) {
        Get.snackbar("Error", "Gagal menyimpan transaksi: $e");
      }
    }

    tampilkanStruk();
    hitungTotal();
  }

  void tampilkanStruk() {
    String storeName = homeController.storeNameFinal.value;
    String address = homeController.storeAddressFinal.value;
    String kasir = userName.value;
    debugPrint(
        "Isi Keranjang sebelum tampilkan struk: ${keranjangBelanja.toList()}");

    if (keranjangBelanja.isEmpty) {
      Get.snackbar("Error", "Keranjang masih kosong!");
      return;
    }

    Get.bottomSheet(
      enableDrag: false,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      Container(
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
                    "$storeName - $address",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Kasir: $kasir",
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
                  ...keranjangBelanja.map((item) {
                    final produk = item['produk'] as MenuModel?;
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
                _buildRow("Subtotal", totalHarga.value),
                _buildRow("Total Harga", totalHarga.value, bold: true),
                _buildRow("Bayar", jumlahBayar.value),
                _buildRow("Kembalian", kembalian.value, bold: true),
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
                      displayText.value = '';
                      keranjangBelanja.clear();
                      jumlahBayar.value = 0;
                      bayarController.clear();
                      kembalian.value = 0;
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
      isScrollControlled: true,
    );
  }

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

  Future<void> printReceipt() async {
    final storeName = homeController.storeNameFinal.value;
    final storeAddress = homeController.storeAddressFinal.value;

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
      storeName,
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        bold: true,
      ),
    );
    bytes +=
        generator.text(storeAddress, styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("--------------------------------");

    // **2. Informasi Transaksi**
    final kasir = userName.value;
    final today = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    bytes += generator.text("Tanggal: $today",
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text("Kasir  : $kasir",
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text("--------------------------------");

    // **3. Header Daftar Produk**
    bytes += generator.text(
      "Nama Produk  Qty  Harga Subtotal",
      styles: PosStyles(bold: true),
    );
    bytes += generator.text("--------------------------------");

    // **4. Daftar Produk**
    debugPrint(
        "Isi Keranjang: ${keranjangBelanja.map((e) => e.toString()).toList()}");

    if (keranjangBelanja.isEmpty) {
      debugPrint("Tidak ada item dalam keranjang!");
      Get.snackbar("Error", "Keranjang masih kosong!");
      return;
    }

    for (var item in keranjangBelanja) {
      final produk = item['produk'] as MenuModel?;
      if (produk == null) continue;

      int hargaSatuan = int.tryParse(produk.price ?? '0') ?? 0;
      int jumlah = item['jumlah'] ?? 0;
      int subTotal = jumlah * hargaSatuan;

      // Format produk dengan rata kiri untuk nama & rata kanan untuk angka
      bytes += generator.row([
        PosColumn(
            text: produk.name ?? '-',
            width: 6,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: "$jumlah x",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: rupiahConverter(hargaSatuan),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      bytes += generator.row([
        PosColumn(
            text: "Subtotal:",
            width: 8,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: rupiahConverter(subTotal),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.text("--------------------------------");

    // **5. Total Harga, Bayar, dan Kembalian**
    bytes += generator.row([
      PosColumn(
          text: "Total Harga:",
          width: 8,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: rupiahConverter(totalHarga.value),
          width: 4,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: "Bayar:", width: 8, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: rupiahConverter(jumlahBayar.value),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: "Kembalian:",
          width: 8,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: rupiahConverter(kembalian.value),
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

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, (user) {
      if (user != null) {
        fetchUserStore(user.uid);
      } else {
        clearUserData();
      }
    });

    getUser();
    // Auto-update kembalian ketika jumlahBayar atau totalHarga berubah
    ever(jumlahBayar, (_) => hitungTotal());
    ever(totalHarga, (_) => hitungTotal());
  }
}
