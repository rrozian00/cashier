// import 'package:cashier/features/order/bloc/order_bloc.dart';
// import 'package:cashier/features/product/models/product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// class OrderPage extends StatelessWidget {
//   const OrderPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => OrderBloc(),
//       child: const OrderView(),
//     );
//   }
// }

// class OrderView extends StatelessWidget {
//   const OrderView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<OrderBloc, OrderState>(
//         builder: (context, state) {
//           if (state is OrderInitial) {
//             context.read<OrderBloc>().add(Fetchroduct());
//           }

//           if (state is OrderLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is OrderError) {
//             return Center(child: Text(state.message));
//           }

//           if (state is OrderLoaded) {
//             return _buildOrderView(context, state);
//           }

//           return const SizedBox();
//         },
//       ),
//     );
//   }

//   Widget _buildOrderView(BuildContext context, OrderLoaded state) {
//     return Column(
//       children: [
//         // Tampilkan produk
//         Expanded(
//           child: ListView.builder(
//             itemCount: state.products.length,
//             itemBuilder: (context, index) {
//               final product = state.products[index];
//               return ListTile(
//                 title: Text(product.name ?? ''),
//                 onTap: () => context.read<OrderBloc>().add(AddToCart(product)),
//               );
//             },
//           ),
//         ),

//         // Tampilkan keranjang
//         Expanded(
//           child: ListView.builder(
//             itemCount: state.cart.length,
//             itemBuilder: (context, index) {
//               final item = state.cart[index];
//               final product = item['produk'] as ProductModel;
//               final quantity = item['jumlah'] as int;

//               return ListTile(
//                 title: Text(product.name ?? ''),
//                 subtitle: Text('$quantity x ${product.price}'),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.remove),
//                       onPressed: () {},
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),

//         // Total dan pembayaran
//         Text('Total: ${state.totalHarga}'),
//         // TextField(
//         //   onChanged: (value) {
//         //     final cleanedNumber = value.replaceAll('.', '');
//         //     final jumlah = int.tryParse(cleanedNumber) ?? 0;
//         //     context.read<OrderBloc>().add(NumberPressed(jumlah));
//         //   },
//         //   controller: TextEditingController(
//         //     text: NumberFormat("#,###", "id_ID").format(state.jumlahBayar),
//         //   ),
//         // ),
//         Text('Kembalian: ${state.kembalian}'),

//         // Tombol aksi
//         ElevatedButton(
//           onPressed: () => context.read<OrderBloc>().add(ClearCart()),
//           child: const Text('Bersihkan Keranjang'),
//         ),
//         ElevatedButton(
//           onPressed: () {},
//           child: const Text('Simpan Transaksi'),
//         ),
//       ],
//     );
//   }
// }
