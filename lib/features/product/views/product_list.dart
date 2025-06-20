import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../order/order/bloc/order_bloc.dart';

import '../../../core/widgets/no_data.dart';
import '../blocs/product_bloc/product_bloc.dart';
import '../models/product_model.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is ProductSuccess) {
            if (state.products.isEmpty) {
              return noData(
                icon: Icons.no_sim_rounded,
                title: "Produk kosong",
                message: "Silahkan tambahkan produk",
              );
            }

            return _buildProductGrid(state.products);
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Selesai"),
        // text: "Selesai",
        // width: 180,
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
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
          );
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductModel product;

  const _ProductItem({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final orderBloc = context.read<OrderBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // color: Theme.of(context).colorScheme.onSecondary,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary,
                spreadRadius: 4,
                blurRadius: 6,
              ),
            ],
          ),
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.primary,
            onLongPress: () =>
                context.read<OrderBloc>().add(RemoveFromCart(product: product)),
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
                context.read<OrderBloc>().add(AddToCartByTap(product: product)),
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
                    child: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        final item = orderBloc.cart.firstWhereOrNull(
                            (e) => e.product.id == product.id);
                        final quantity = item?.product.quantity ?? 0;

                        return quantity > 0
                            ? Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.red,
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
                      },
                    ))
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
              // color: purple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
