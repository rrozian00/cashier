import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/features/product/blocs/cubit/category_cubit.dart';
import 'package:cashier/features/product/models/product_model.dart';
import 'package:cashier/features/product/views/detail_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/widgets/my_alert_dialog.dart';
import '../../../core/widgets/no_data.dart';
import '../../../routes/app_pages.dart';
import '../blocs/product_bloc/product_bloc.dart';
import 'edit_product_view.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductDeleteSuccess) {
          context.read<ProductBloc>().add(ProductGetRequested());
        }
        if (state is ProductFailed) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error")));
          debugPrint(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Produk"),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          buildWhen: (previous, current) {
            return current is ProductSuccess ||
                current is ProductLoading ||
                current is ProductDeleteLoading;
          },
          builder: (context, state) {
            if (state is ProductLoading || state is ProductDeleteLoading) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is ProductSuccess && state.products.isEmpty) {
              return noData(
                  title: "Produk Kosong", message: "Silahkan Tambah Produk !");
            }

            if (state is ProductSuccess) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //TODO:tampilkan produk sesuai kategori
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     ElevatedButton(
                  //         onPressed: () {
                  //           context
                  //               .read<CategoryCubit>()
                  //               .selectCategory("Member");
                  //         },
                  //         child: Text("Member")),
                  //     ElevatedButton(
                  //         onPressed: () {
                  //           context
                  //               .read<CategoryCubit>()
                  //               .selectCategory("Produk");
                  //         },
                  //         child: Text("Produk")),
                  //   ],
                  // ),
                  // Expanded(
                  //     flex: 1,
                  //     child: SizedBox(
                  //       height: 20,
                  //     )),
                  BlocBuilder<CategoryCubit, String>(
                    builder: (context, category) {
                      if (category == "Member") {
                        return Center(child: Text("Oke"));
                      }
                      return Expanded(
                        flex: 50,
                        child: ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final datas = state.products[index];
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3),
                                child: _buildListile(context, datas));
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton(
          child: Text("Tambah"),
          onPressed: () => Navigator.pushNamed(context, Routes.addMenus),
        ),
      ),
    );
  }
}

Widget _buildListile(BuildContext context, ProductModel datas) {
  return Card(
    elevation: 4,
    color: Theme.of(context).colorScheme.secondary,
    // color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduct(product: datas),
          )),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: datas.image != null && datas.image!.isNotEmpty
            ? ClipOval(
                child: Hero(
                  tag: "product-${datas.id}",
                  child: Image.network(
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      datas.image ?? ''),
                ),
              )
            : Image.asset(
                'assets/icons/icon.png',
                fit: BoxFit.cover,
              ),
      ),
      title: Text(
        datas.name ?? '-',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        rupiahConverter(
          int.tryParse(datas.price ?? "") ?? 0,
        ),
        // datas.image ?? '',
        style: TextStyle(),
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () {
              Get.dialog(MyAlertDialog(
                  onCancelColor: Colors.green,
                  onConfirmColor: Colors.red,
                  onConfirmText: "Hapus",
                  contentText: "Apakah anda yakin akan menghapus produk ini ?",
                  onConfirm: () {
                    context
                        .read<ProductBloc>()
                        .add(ProductDeleteRequested(datas.id!));
                  }));
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductView(productData: datas),
                )),
            icon: Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
    ),
  );
}
