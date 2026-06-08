import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/my_snackbar.dart';
import '../../../core/utils/rupiah_converter.dart';
import '../../../core/widgets/my_alert_dialog.dart';
import '../../../core/widgets/no_data.dart';
import '../blocs/cubit/category_cubit.dart';
import '../blocs/product_bloc.dart';
import '../models/product_model.dart';
import 'add_product_view.dart';
import 'detail_product.dart';
import 'edit_product_view.dart';

class AllProductView extends StatelessWidget {
  const AllProductView({super.key});

  @override
  Widget build(BuildContext context) {
    // Pemicu awal untuk mengambil data saat halaman dibuka pertama kali
    context.read<ProductBloc>().add(ProductGetRequested());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Produk"),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductFailed) {
            showMysnackbar(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is ProductSuccess) {
            if (state.products.isEmpty) {
              return noData(
                title: "Produk Kosong",
                message: "Silahkan Tambah Produk !",
              );
            }

            return Column(
              children: [
                // 🔹 MENU TAB KATEGORI (Aktifkan kembali dengan rapi)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => context
                            .read<CategoryCubit>()
                            .selectCategory("Member"),
                        child: const Text("Member"),
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<CategoryCubit>()
                            .selectCategory("Produk"),
                        child: const Text("Produk"),
                      ),
                    ],
                  ),
                ),

                // 🔹 LIST PRODUK BERDASARKAN FILTER KATEGORI
                Expanded(
                  child: BlocBuilder<CategoryCubit, String>(
                    builder: (context, currentCategory) {
                      // Filter list produk secara langsung (on-the-fly) menghemat query database
                      final filteredProducts = state.products
                          .where((product) =>
                              product.category?.toLowerCase() ==
                              currentCategory.toLowerCase())
                          .toList();

                      if (filteredProducts.isEmpty) {
                        return noData(
                          title: "Kategori Kosong",
                          message:
                              "Belum ada data untuk kategori $currentCategory",
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredProducts.length,
                        padding: const EdgeInsets.only(
                            bottom: 80), // Beri jarak agar tidak tertutup FAB
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3),
                            child: _buildListTile(context, product),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text("Tambah"),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddProductView(),
          ),
        ),
      ),
    );
  }
}

Widget _buildListTile(BuildContext context, ProductModel datas) {
  return Card(
    elevation: 4,
    color: Theme.of(context).colorScheme.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailProduct(product: datas),
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: datas.image != null && datas.image!.isNotEmpty
            ? ClipOval(
                child: Hero(
                  tag: "product-${datas.id}",
                  child: Image.network(
                    datas.image!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              )
            : Image.asset(
                'assets/icons/icon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.fastfood),
              ),
      ),
      title: Text(
        datas.name ?? '-',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        rupiahConverter(datas.price ?? 0),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize
            .min, // WAJIB Row dengan mainAxisSize min untuk trailing yang rapi daripada Wrap
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => MyAlertDialog(
                    onCancelColor: Colors.green,
                    onConfirmColor: Colors.red,
                    onConfirmText: "Hapus",
                    contentText:
                        "Apakah anda yakin akan menghapus produk ini ?",
                    onConfirm: () {
                      // Eksekusi hapus menggunakan context halaman utama
                      context
                          .read<ProductBloc>()
                          .add(ProductDeleteRequested(datas.id!));
                      Navigator.pop(dialogContext);
                    }),
              );
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductView(productData: datas),
              ),
            ),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    ),
  );
}
