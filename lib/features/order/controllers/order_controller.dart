import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/utils/get_store_id.dart';
import 'package:cashier/core/utils/get_user_data.dart';
import 'package:cashier/features/menu/models/product_model.dart';
import 'package:cashier/features/order/utils/show_receipt.dart';
import 'package:cashier/features/order/models/order_model.dart';
import 'package:cashier/features/store/models/store_model.dart';
import 'package:cashier/features/user/models/user_model.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final storeData = Rxn<StoreModel>();
  final userData = Rxn<UserModel>();
  var selectedProduct = Rxn<ProductModel>(); // Kembalikan selectedProduk

  final product = <ProductModel>[].obs;
  final cart = <Map<String, dynamic>>[].obs;

  var isOwner = false.obs;
  var isEmployee = false.obs;
  final isLoading = false.obs;

  var totalHarga = 0.obs;
  var jumlahBayar = 0.obs;
  var kembalian = 0.obs;

  var displayText = ''.obs;

  final scannedBarcode = ''.obs;

  final bayarController = TextEditingController(); // Kembalikan bayarController

  void addCartByBarcode(String barcode) {
    // Cari produk berdasarkan barcode
    var item = product.firstWhereOrNull((menu) => menu.barcode == barcode);

    if (item != null) {
      addCart(item);
    } else {
      Get.snackbar("Error", "Produk tidak ditemukan");
    }
  }

  void clearCart() {
    cart.clear();
    totalHarga.value = 0;
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

  void clearTap() {
    displayText.value = '';
    jumlahBayar.value = 0;
  }

  void addValueCart(ProductModel item, int currentJumlah) {
    final TextEditingController productC =
        TextEditingController(text: currentJumlah.toString());

    Get.dialog(Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Masukkan jumlah", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              controller: productC,
              decoration: InputDecoration(
                hintText: "Contoh: 5",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: purple),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            myGreenElevated(
              text: "Simpan",
              onPress: () {
                int jumlah = int.tryParse(productC.text) ?? 1;

                // Cek apakah produk sudah ada di keranjang

                for (var el in cart) {
                  if (el['produk'] == item) {
                    if (jumlah != 0) {
                      el['jumlah'] = jumlah;
                    }
                    break;
                  }
                }

                cart.refresh();
                hitungTotal();
                Get.back();
              },
            )
          ],
        ),
      ),
    ));
  }

  void addCart(ProductModel item) {
    bool productExist = cart.any((el) => el['produk'] == item);
    if (productExist) {
      for (var el in cart) {
        if (el['produk'] == item) {
          el['jumlah']++;
        }
      }
    } else {
      cart.add({'produk': item, 'jumlah': 1});
    }

    cart.refresh(); // Tambahkan ini agar UI diperbarui
    hitungTotal();
  }

  void removeCart(ProductModel item) {
    for (var el in cart) {
      if (el['produk'] == item) {
        if (el['jumlah'] > 1) {
          el['jumlah']--;
        } else {
          cart.remove(el);
        }
        break;
      }
    }
    cart.refresh(); // Tambahkan ini agar UI diperbarui
    hitungTotal();
  }

  void deleteCart(ProductModel item) {
    cart.removeWhere((el) => el['produk'] == item);
    cart.refresh();
    hitungTotal();
  }

  void hitungTotal() {
    int total = 0;
    for (var item in cart) {
      final produk = item['produk'] as ProductModel;
      final jumlah = item['jumlah'] as int;
      total += (int.tryParse(produk.price ?? '0') ?? 0) * jumlah;
    }
    totalHarga.value = total;

    // Pastikan kembalian diperbarui secara real-time
    kembalian.value = (jumlahBayar.value >= totalHarga.value)
        ? jumlahBayar.value - totalHarga.value
        : 0;
  }

  void insertOrder() async {
    final storeId = storeData.value?.id;
    if (storeId == null) {
      debugPrint("StoreId belum ditemukan di inserTransaksi");
      return;
    }

    if (jumlahBayar.value < totalHarga.value) {
      debugPrint("Jumlah Bayar Kurang");
      return;
    }

    final createdAt = Timestamp.now();

    final docRef =
        _firestore.collection('stores').doc(storeId).collection('orders').doc();

    final model = OrderModel(
      id: docRef.id,
      payment: jumlahBayar.value.toString(),
      products: cart.map((e) {
        final produk = e['produk'] as ProductModel;
        final jumlah = e['jumlah'] as int;

        return ProductModel(
          id: produk.id,
          barcode: produk.barcode,
          name: produk.name,
          price: produk.price,
          quantity: jumlah.toString(),
        );
      }).toList(),
      refund: kembalian.value.toString(),
      total: totalHarga.value.toString(),
      createdAt: createdAt,
    );

    try {
      await docRef.set(model.toMap());
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan transaksi: $e");
    }

    hitungTotal();
    Get.bottomSheet(
      enableDrag: false,
      isDismissible: false,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      isScrollControlled: true,
      backgroundColor: white,
      FractionallySizedBox(heightFactor: 0.75, child: ShowReceipt()),
    );
  }

  @override
  void onInit() {
    super.onInit();

    // Auto-update kembalian ketika jumlahBayar atau totalHarga berubah
    ever(jumlahBayar, (_) => hitungTotal());
    ever(totalHarga, (_) => hitungTotal());
  }

  @override
  void onReady() async {
    super.onReady();
    try {
      userData.value = await getUserData();
      storeData.value = await getStoreData();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
