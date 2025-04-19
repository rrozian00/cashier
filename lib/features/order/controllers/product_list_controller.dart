import 'dart:async';

import 'package:cashier/features/menu/models/product_model.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final orderController = Get.find<OrderController>();

  StreamSubscription? _productSubscription;
  final isLoading = false.obs;

  void fetchProductRealTime() {
    orderController.product.clear();

    if (orderController.storeData.value == null) {
      Get.snackbar("Error", "Toko belum ditemukan");
      return;
    }

    final storeId = orderController.storeData.value?.id;

    isLoading.value = true;

    _productSubscription?.cancel();

    _productSubscription = _firestore
        .collection('stores')
        .doc(storeId)
        .collection('menus')
        .snapshots()
        .listen((snapshot) {
      orderController.product.assignAll(snapshot.docs
          .map((snapshot) => ProductModel.fromMap(snapshot.data()))
          .toList());
    }, onError: (e) {
      debugPrint("Gagal mengambil fetchProduct realtime: $e");
      isLoading.value = false;
    });
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProductRealTime();
  }
}
