import 'dart:io';

import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/features/order/controllers/product_list_controller.dart';

class ProductList extends GetView<ProductListController> {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(
      //   titleText: "Daftar Produk",
      //   actions: [
      //     IconButton(
      //         onPressed: () => controller.orderController.clearCart(),
      //         icon: Icon(
      //           Icons.refresh,
      //           color: blue,
      //         ))
      //   ],
      // ),
      body: Column(
        children: [
          homeIndicator(),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.isTrue) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: purple,
                    ),
                  );
                }
                if (controller.orderController.product.isEmpty) {
                  return noData(
                      icon: Icons.no_sim_rounded,
                      title: "Produk kosong",
                      message: "Silahkan tambahkan produk");
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: GridView.builder(
                    itemCount: controller.orderController.product.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.5),
                    itemBuilder: (context, index) {
                      final data = controller.orderController.product[index];

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: softBlack,
                                  spreadRadius: 4, // makin gede makin menyebar
                                  blurRadius:
                                      6, // makin gede makin halus bayangannya
                                ),
                              ],
                            ),
                            child: InkWell(
                              onLongPress: () =>
                                  controller.orderController.deleteCart(data),
                              borderRadius: BorderRadius.circular(12),
                              splashColor: purple,
                              onTap: () =>
                                  controller.orderController.addCart(data),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: Image.file(
                                        File(data.image ?? ''),
                                        width: Get.width / 5,
                                        height: Get.height / 8,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    right: 6,
                                    child: Obx(() {
                                      final jumlah = controller
                                              .orderController.cart
                                              .firstWhereOrNull((e) =>
                                                  e['produk'].id ==
                                                  data.id)?['jumlah'] ??
                                          0;
                                      return jumlah > 0
                                          ? Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "$jumlah",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    // fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink();
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              data.name ?? "",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: purple,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: myGreenElevated(
        onPress: () => Get.back(),
        text: "Selesai",
        width: 180,
      ),
    );
  }
}
