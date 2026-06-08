// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../core/utils/rupiah_converter.dart';
// import '../../../scanner/views/scanner_view.dart';
// import '../../../product/blocs/product_bloc.dart';
// import '../../../product/models/product_model.dart';
// import '../../../product/views/product_list.dart';
// import '../../check_out/bloc/check_out_bloc.dart';
// import '../../check_out/views/check_out_view.dart';
// import '../bloc/order_bloc.dart';

// class OrderView extends StatelessWidget {
//   const OrderView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OrderBloc, OrderState>(
//       builder: (context, state) {
//         final orderBloc = context.read<OrderBloc>();

//         return Scaffold(
//           // appBar: AppBar(
//           //   // leading: IconButton(
//           //   //     onPressed: () {
//           //   //       context.read<ThemeCubit>().toggleTheme();
//           //   //     },
//           //   //     icon: Icon(Icons.palette_outlined)),
//           //   title: Text("Keranjang"),
//           //   actions: [
//           // IconButton(
//           //   color: Colors.blue,
//           //   onPressed: () => orderBloc.add(ClearCart()),
//           //   icon: Icon(Icons.clear,
//           //       color: Theme.of(context).colorScheme.error),
//           // ),
//           //   ],
//           // ),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: SafeArea(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           color: Colors.blue,
//                           onPressed: () => orderBloc.add(ClearCart()),
//                           icon: Icon(Icons.clear,
//                               color: Theme.of(context).colorScheme.error),
//                         ),
//                       ],
//                     ),
//                     // Shopping Cart
//                     Expanded(
//                       flex: 4,
//                       child: _buildCartList(context, orderBloc),
//                     ),
//                     _buildTotalPriceSection(context, orderBloc),
//                     const Divider(),
//                     _buildActionButtons(context, orderBloc),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCartList(BuildContext context, OrderBloc orderBloc) {
//     if (orderBloc.state is OrderLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (orderBloc.cart.isEmpty) {
//       return Center(
//         child: Column(
//           // spacing: 10,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/shopping-cart.png',
//               height: 50,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Text(
//               "Keranjang Kosong",
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 // color: Colors.deepPurple,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               "Silahkan pilih Daftar Produk / Scan Barcode",
//               style: TextStyle(
//                 // color: Colors.black,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: orderBloc.cart.length,
//       itemBuilder: (context, index) {
//         final item = orderBloc.cart[index];
//         final product = item;
//         final quantity = item.quantity;

//         return Dismissible(
//           confirmDismiss: (direction) async {
//             return await showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text('Konfirmasi'),
//                 content: const Text(
//                   'Yakin ingin menghapus produk ini dari keranjang?',
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(false),
//                     child: const Text('Batal'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => Navigator.of(context).pop(true),
//                     child: const Text('Hapus'),
//                   ),
//                 ],
//               ),
//             );
//           },
//           key: Key(product.id ?? UniqueKey().toString()),
//           direction: DismissDirection.endToStart,
//           background: Container(
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             alignment: Alignment.centerRight,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: const Icon(Icons.delete),
//           ),
//           onDismissed: (direction) {
//             orderBloc.add(RemoveFromCart(product: product));
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 3.0),
//             child: Card(
//               // shadowColor: Theme.of(context).colorScheme.primary,
//               elevation: 4,
//               color: Theme.of(context).colorScheme.secondary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Stack(
//                 children: [
//                   ListTile(
//                     onTap: () => _showQuantityDialog(context, product),
//                     leading: ClipOval(
//                       child: Image.network(product.image ?? ""),
//                     ),
//                     title: Text(
//                       product.name ?? 'Nama Produk',
//                       style: TextStyle(
//                         // color: purple,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(
//                       rupiahConverter(product.price ?? 0),
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.remove_rounded),
//                           onPressed: () => orderBloc
//                               .add(DecrementCartItem(product: product)),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.add_rounded),
//                           onPressed: () => orderBloc
//                               .add(IncrementCartItem(product: product)),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     top: 6,
//                     left: 10,
//                     child: Container(
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Theme.of(context).colorScheme.onSurface),
//                       height: 30,
//                       width: 30,
//                       child: Center(
//                         child: Text(
//                           quantity.toString(),
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Theme.of(context).colorScheme.surface,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTotalPriceSection(BuildContext context, OrderBloc orderBloc) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           orderBloc.totalPrice != 0
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Total"),
//                     Text(
//                       rupiahConverter(orderBloc.totalPrice),
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.bold,
//                         // color: purple,
//                         fontSize: 24,
//                       ),
//                     ),
//                   ],
//                 )
//               : Container(),
//           orderBloc.cart.isNotEmpty
//               ? ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).colorScheme.tertiary),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CheckOutView(
//                             carts: orderBloc.cart,
//                           ),
//                         ));
//                     context.read<CheckOutBloc>().add(
//                         InitCheckOut(orderBloc.totalPrice, orderBloc.cart));
//                   },
//                   child: Text(
//                     "BAYAR",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, OrderBloc orderBloc) {
//     final productBloc = context.read<ProductBloc>();

//     return Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 6.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             ElevatedButton(
//               child: Text("Daftar Produk"),
//               // icon: Icons.list,
//               // text: "Daftar Produk",
//               onPressed: () {
//                 showModalBottomSheet(
//                   showDragHandle: true,
//                   context: context,
//                   clipBehavior: Clip.hardEdge,
//                   builder: (context) => const ProductList(),
//                 );
//                 productBloc.add(ProductGetRequested());
//               },
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ScannerView()),
//                 );

//                 if (result != null && result.isNotEmpty) {
//                   orderBloc.add(AddToCartByBarcode(barcodes: result));
//                 }
//               },
//               child: Text("Scan Barcode"),
//               // text: "Scan Barcode",
//               // icon: Icons.qr_code_scanner_rounded,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _showQuantityDialog(BuildContext context, ProductModel product) {
//   final controller = TextEditingController(
//     text: product.quantity.toString(),
//   );

//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text(product.name ?? ''),
//       content: TextField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(labelText: 'Jumlah'),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('Batal'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             final newQty = int.tryParse(controller.text) ?? 0;
//             context.read<OrderBloc>().add(
//                   UpdateCartItem(
//                     product: product,
//                     quantity: newQty,
//                   ),
//                 );
//             Navigator.pop(context);
//           },
//           child: Text('Simpan'),
//         ),
//       ],
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/rupiah_converter.dart';
import '../../../scanner/views/scanner_view.dart';
import '../../../product/blocs/product_bloc.dart';
import '../../../product/models/product_model.dart';
import '../../../product/views/product_list.dart';
import '../../check_out/bloc/check_out_bloc.dart';
import '../../check_out/views/check_out_view.dart';
import '../bloc/order_bloc.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Satukan tumpuan builder menggunakan BlocBuilder utama agar seluruh komponen tersinkronisasi
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        final orderBloc = context.read<OrderBloc>();

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tombol Clear Cart di Pojok Atas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: orderBloc.cart.isEmpty
                            ? null
                            : () => orderBloc.add(ClearCart()),
                        icon: Icon(
                          Icons.clear_all_rounded,
                          color: orderBloc.cart.isEmpty
                              ? Colors.grey
                              : Theme.of(context).colorScheme.error,
                        ),
                        tooltip: "Kosongkan Keranjang",
                      ),
                    ],
                  ),

                  // Shopping Cart List Area
                  Expanded(
                    child: _buildCartList(context, state, orderBloc),
                  ),

                  const Divider(height: 24),

                  // Bagian Total Harga dan Tombol Bayar
                  _buildTotalPriceSection(context, orderBloc),

                  const SizedBox(height: 12),

                  // Tombol Aksi Bawah (Daftar Produk & Scan Barcode)
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartList(
      BuildContext context, OrderState state, OrderBloc orderBloc) {
    if (state is OrderLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (orderBloc.cart.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/shopping-cart.png',
                height: 80,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.shopping_cart_outlined,
                    size: 60,
                    color: Colors.grey.shade400),
              ),
              const SizedBox(height: 16),
              Text(
                "Keranjang Kosong",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Silahkan pilih Daftar Produk / Scan Barcode",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: orderBloc.cart.length,
      padding: const EdgeInsets.only(bottom: 12),
      itemBuilder: (context, index) {
        final product = orderBloc.cart[index];
        final quantity = product.quantity ?? 0;

        return Dismissible(
          key: Key("cart-${product.id}-${index}"),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: Text(
                    'Yakin ingin menghapus ${product.name} dari keranjang?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Hapus',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            orderBloc.add(RemoveFromCart(product: product));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Stack(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: () =>
                        _showQuantityDialog(context, product, orderBloc),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey.shade200,
                      child: ClipOval(
                        child: Image.network(
                          product.image ?? "",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(
                      product.name ?? 'Nama Produk',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        rupiahConverter(product.price ?? 0),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded,
                              color: Colors.amber),
                          onPressed: () => orderBloc
                              .add(DecrementCartItem(product: product)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline_rounded,
                              color: Colors.blue),
                          onPressed: () => orderBloc
                              .add(IncrementCartItem(product: product)),
                        ),
                      ],
                    ),
                  ),

                  // Badge Indikator Jumlah Produk (Dipindahkan ke pojok kiri agar tidak menutupi aksi)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      height: 24,
                      width: 24,
                      child: Center(
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalPriceSection(BuildContext context, OrderBloc orderBloc) {
    if (orderBloc.cart.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Total Tagihan",
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            Text(
              rupiahConverter(orderBloc.totalPrice),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckOutView(carts: orderBloc.cart),
              ),
            );
            context
                .read<CheckOutBloc>()
                .add(InitCheckOut(orderBloc.totalPrice, orderBloc.cart));
          },
          icon: const Icon(Icons.point_of_sale_rounded, size: 18),
          label: const Text("BAYAR",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.grid_view_rounded),
              label: const Text("Daftar Produk"),
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  isScrollControlled: true,
                  clipBehavior: Clip.hardEdge,
                  builder: (context) => const FractionallySizedBox(
                    heightFactor: 0.85,
                    child: ProductList(),
                  ),
                );
                context.read<ProductBloc>().add(ProductGetRequested());
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text("Scan Barcode"),
              onPressed: () async {
                final List<String> result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScannerView()),
                );

                if (result.isNotEmpty) {
                  context
                      .read<OrderBloc>()
                      .add(AddToCartByBarcode(barcodes: result));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 SOLUSI MEMORY LEAK: Menggunakan StatefulBuilder khusus untuk melokalisasi siklus hidup Controller
  void _showQuantityDialog(
      BuildContext context, ProductModel product, OrderBloc orderBloc) {
    showDialog(
      context: context,
      builder: (context) {
        final qtyController =
            TextEditingController(text: product.quantity.toString());

        return AlertDialog(
          title: Text("Ubah Jumlah: ${product.name}"),
          content: TextField(
            controller: qtyController,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Jumlah Item',
              border: OutlineInputBorder(),
              suffixText: "pcs",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                qtyController.dispose(); // Hapus dari memori RAM
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newQty = int.tryParse(qtyController.text) ?? 0;
                if (newQty > 0) {
                  orderBloc
                      .add(UpdateCartItem(product: product, quantity: newQty));
                } else {
                  orderBloc.add(RemoveFromCart(product: product));
                }
                qtyController
                    .dispose(); // Pastikan di-dispose setelah selesai dipakai
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
