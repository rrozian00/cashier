import 'package:cashier/core/widgets/home_indicator.dart';
import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/features/order/controllers/order_controller.dart';
import 'package:cashier/features/product/bloc/product_bloc.dart';
import 'package:cashier/features/product/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/no_data.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());

    return Scaffold(
      backgroundColor: softGrey,
      body: Column(
        children: [
          homeIndicator(),
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }

                if (state is ProductSuccess) {
                  if (state.products.isEmpty) {
                    return noData(
                      icon: Icons.no_sim_rounded,
                      title: "Produk kosong",
                      message: "Silahkan tambahkan produk",
                    );
                  }

                  return _buildProductGrid(state.products, orderController);
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: myGreenElevated(
        onPress: () => Navigator.pop(context),
        text: "Selesai",
        width: 180,
      ),
    );
  }

  Widget _buildProductGrid(
      List<ProductModel> products, OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.5,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductItem(
            product: product,
            orderController: orderController,
          );
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductModel product;
  final OrderController orderController;

  const _ProductItem({
    required this.product,
    required this.orderController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: softBlack,
                spreadRadius: 4,
                blurRadius: 6,
              ),
            ],
          ),
          child: InkWell(
            onLongPress: () => orderController.deleteCart(product),
            borderRadius: BorderRadius.circular(12),
            splashColor: purple,
            onTap: () => orderController.addCart(product),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.network(
                      product.image ?? '',
                      width: Get.width / 5,
                      height: Get.height / 8,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Obx(() {
                    final item = orderController.cart
                        .firstWhereOrNull((e) => e['produk'].id == product.id);
                    final quantity = item?['jumlah'] ?? 0;

                    return quantity > 0
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "$quantity",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  }),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            product.name ?? "",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: purple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
