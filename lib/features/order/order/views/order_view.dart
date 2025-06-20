import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/rupiah_converter.dart';
import '../../../../core/utils/scanner_page.dart';
import '../../../product/blocs/product_bloc/product_bloc.dart';
import '../../../product/models/product_model.dart';
import '../../../product/views/product_list.dart';
import '../../check_out/bloc/check_out_bloc.dart';
import '../../check_out/views/check_out_view.dart';
import '../bloc/order_bloc.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        final orderBloc = context.read<OrderBloc>();

        return Scaffold(
          // appBar: AppBar(
          //   // leading: IconButton(
          //   //     onPressed: () {
          //   //       context.read<ThemeCubit>().toggleTheme();
          //   //     },
          //   //     icon: Icon(Icons.palette_outlined)),
          //   title: Text("Keranjang"),
          //   actions: [
          // IconButton(
          //   color: Colors.blue,
          //   onPressed: () => orderBloc.add(ClearCart()),
          //   icon: Icon(Icons.clear,
          //       color: Theme.of(context).colorScheme.error),
          // ),
          //   ],
          // ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          color: Colors.blue,
                          onPressed: () => orderBloc.add(ClearCart()),
                          icon: Icon(Icons.clear,
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
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
          ),
        );
      },
    );
  }

  Widget _buildCartList(BuildContext context, OrderBloc orderBloc) {
    if (orderBloc.cart.isEmpty) {
      return Center(
        child: Column(
          // spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/shopping-cart.png',
              height: 50,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Keranjang Kosong",
              style: GoogleFonts.poppins(
                fontSize: 18,
                // color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Silahkan pilih Daftar Produk / Scan Barcode",
              style: TextStyle(
                // color: Colors.black,
                fontWeight: FontWeight.w400,
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
        final quantity = item.product.quantity;

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
                  ElevatedButton(
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
            child: const Icon(Icons.delete),
          ),
          onDismissed: (direction) {
            orderBloc.add(RemoveFromCart(product: product));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Card(
              // shadowColor: Theme.of(context).colorScheme.primary,
              elevation: 4,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  ListTile(
                    onTap: () => _showQuantityDialog(context, product),
                    leading: ClipOval(
                      child: Image.network(product.image ?? ""),
                    ),
                    title: Text(
                      product.name ?? 'Nama Produk',
                      style: TextStyle(
                        // color: purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      rupiahConverter(int.tryParse(product.price ?? '') ?? 0),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_rounded),
                          onPressed: () => orderBloc
                              .add(DecrementCartItem(product: product)),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_rounded),
                          onPressed: () => orderBloc
                              .add(IncrementCartItem(product: product)),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onSurface),
                      height: 30,
                      width: 30,
                      child: Center(
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          textAlign: TextAlign.center,
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
                        // color: purple,
                        fontSize: 24,
                      ),
                    ),
                  ],
                )
              : Container(),
          orderBloc.cart.isNotEmpty
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckOutView(orderBloc: orderBloc),
                        ));
                    context
                        .read<CheckOutBloc>()
                        .add(InitCheckOut(orderBloc.totalPrice));
                  },
                  child: Text(
                    "BAYAR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
            ElevatedButton(
              child: Text("Daftar Produk"),
              // icon: Icons.list,
              // text: "Daftar Produk",
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  clipBehavior: Clip.hardEdge,
                  builder: (context) => const ProductList(),
                );
                productBloc.add(ProductGetRequested());
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScannerPage()),
                );

                if (result != null && result != "-1") {
                  orderBloc.add(AddToCartByBarcode(barcode: result));
                }
              },
              child: Text("Scan Barcode"),
              // text: "Scan Barcode",
              // icon: Icons.qr_code_scanner_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

void _showQuantityDialog(BuildContext context, ProductModel product) {
  final controller = TextEditingController(
    text: product.quantity.toString(),
  );

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(product.name ?? ''),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Jumlah'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            final newQty = int.tryParse(controller.text) ?? 0;
            context.read<OrderBloc>().add(
                  UpdateCartItem(
                    product: product,
                    quantity: newQty,
                  ),
                );
            Navigator.pop(context);
          },
          child: Text('Simpan'),
        ),
      ],
    ),
  );
}
