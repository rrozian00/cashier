import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/core/widgets/no_data.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductList extends GetView<OrderController> {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          actions: [
            TextButton(
              onPressed: () {
                controller.fetchProduct();
              },
              // child: Icon(
              //   Icons.refresh_rounded,
              //   color: red,
              // ),
              child: Text(
                "Refresh",
                style: TextStyle(color: green),
              ),
            )
          ],
          titleText: "Daftar Produk",
        ),
        body: Obx(
          () {
            if (controller.isLoading.isTrue) {
              return Center(
                child: CircularProgressIndicator(
                  color: purple,
                ),
              );
            }
            if (controller.product.isEmpty) {
              return noData(
                  icon: Icons.no_sim_rounded,
                  title: "Produk kosong",
                  message: "Silahkan tambahkan produk");
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final data = controller.product[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    color: white,
                    elevation: 4,
                    child: ListTile(
                      trailing: Text(
                        "Masukkan Keranjang",
                        style: TextStyle(color: red),
                      ),
                      leading: Text(
                        "${index + 1}",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        controller.tambahKeKeranjang(data);
                        Get.back();
                      },
                      title: Text(
                        data.name ?? '',
                        style: GoogleFonts.poppins(
                            color: purple, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(data.barcode ?? ''),
                    ),
                  ),
                );
              },
              itemCount: controller.product.length,
            );
          },
        ));
  }
}
