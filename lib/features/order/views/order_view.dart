import 'package:cashier/features/order/check_out/bloc/check_out_bloc.dart';

import '../blocs/order_bloc/order_bloc.dart';
import '../check_out/check_out_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';
import '../../../core/utils/rupiah_converter.dart';
import '../../../core/utils/scanner_page.dart';
import '../../../core/widgets/my_appbar.dart';
import '../../../core/widgets/my_elevated.dart';
import '../../product/bloc/product_bloc.dart';
import '../../product/views/product_list.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        final orderBloc = context.read<OrderBloc>();

        return Scaffold(
          backgroundColor: softGrey,
          appBar: MyAppBar(
            titleText: 'Pilih Produk',
            actions: [
              IconButton(
                color: blue,
                onPressed: () => orderBloc.add(ClearCart()),
                icon: Icon(Icons.clear, color: red),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Shopping Cart
                  Expanded(
                    flex: 4,
                    child: _buildCartList(context, orderBloc),
                  ),
                  _buildTotalPriceSection(context, orderBloc),
                  const Divider(),
                  _buildActionButtons(context, orderBloc),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartList(BuildContext context, OrderBloc orderBloc) {
    if (orderBloc.cart.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty.png', height: 70),
            Text(
              "Keranjang Kosong",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Silahkan pilih Daftar Produk / Scan Barcode",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orderBloc.cart.length,
      itemBuilder: (context, index) {
        final item = orderBloc.cart[index];
        final product = item.product;
        final quantity = item.quantity;

        return Dismissible(
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text(
                  'Yakin ingin menghapus produk ini dari keranjang?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );
          },
          key: Key(product.id ?? UniqueKey().toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            orderBloc.add(RemoveFromCart(product: product));
          },
          child: Card(
            elevation: 4,
            color: white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                ListTile(
                  onTap: () => orderBloc.add(UpdateCartItem(
                    product: product,
                    quantity: quantity,
                  )),
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(product.image ?? ""),
                  ),
                  title: Text(
                    product.name ?? 'Nama Produk',
                    style: GoogleFonts.poppins(
                      color: purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    rupiahConverter(int.tryParse(product.price ?? '') ?? 0),
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_rounded, color: red),
                        onPressed: () =>
                            orderBloc.add(DecrementCartItem(product: product)),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_rounded, color: green),
                        onPressed: () =>
                            orderBloc.add(IncrementCartItem(product: product)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pink,
                    ),
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalPriceSection(BuildContext context, OrderBloc orderBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          orderBloc.totalPrice != 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total"),
                    Text(
                      rupiahConverter(orderBloc.totalPrice),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: purple,
                        fontSize: 24,
                      ),
                    ),
                  ],
                )
              : Container(),
          orderBloc.cart.isNotEmpty
              ? myGreenElevated(
                  width: 150,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckOutView(
                            orderBloc: orderBloc,
                          ),
                        ));

                    context
                        .read<CheckOutBloc>()
                        .add(InitCheckOut(orderBloc.totalPrice));
                  },
                  child: Text(
                    "BAYAR",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, OrderBloc orderBloc) {
    final productBloc = context.read<ProductBloc>();

    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            myPurpleIconElevated(
              icon: Icons.list,
              text: "Daftar Produk",
              onPress: () {
                showModalBottomSheet(
                  context: context,
                  clipBehavior: Clip.hardEdge,
                  builder: (context) => const ProductList(),
                );
                productBloc.add(ProductGetRequested());
              },
            ),
            myPurpleIconElevated(
              onPress: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScannerPage()),
                );

                if (result != null && result != "-1") {
                  orderBloc.add(AddToCartByBarcode(barcode: result));
                }
              },
              text: "Scan Barcode",
              icon: Icons.qr_code_scanner_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
