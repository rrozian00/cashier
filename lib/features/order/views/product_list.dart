import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductList extends GetView<OrderController> {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleText: "List",
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final data = controller.produk[index];
          return ListTile(
            title: Text(data.name ?? ''),
            subtitle: Text(data.barcode ?? ''),
          );
        },
        itemCount: controller.produk.length,
      ),
    );
  }
}
