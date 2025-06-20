import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../blocs/product_bloc/product_bloc.dart';
import '../models/product_model.dart';

class EditProductView extends StatefulWidget {
  final ProductModel productData; // Receive data as parameter

  const EditProductView({super.key, required this.productData});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  late final TextEditingController productCode;
  late final TextEditingController nameC;
  late final TextEditingController priceC;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with product data
    productCode = TextEditingController(text: widget.productData.barcode ?? '');
    nameC = TextEditingController(text: widget.productData.name ?? '');
    priceC = TextEditingController(
        text:
            rupiahConverter(int.tryParse(widget.productData.price ?? '') ?? 0));
  }

  @override
  void dispose() {
    productCode.dispose();
    nameC.dispose();
    priceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductEditSuccess) {
          context.read<ProductBloc>().add(ProductGetRequested());
          Navigator.pop(context);
        }
        if (state is PickImageError) {
          Get.snackbar("Error", state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Produk"),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductEditLoading) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => context
                          .read<ProductBloc>()
                          .add(ProductPickImageReq()),
                      child: Stack(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withAlpha(100),
                            ),
                            child: ClipOval(
                                child: BlocBuilder<ProductBloc, ProductState>(
                              builder: (context, state) {
                                if (state is PickImageSuccess) {
                                  if (state.pickedImage.isNotEmpty) {
                                    return Image.file(
                                        fit: BoxFit.cover,
                                        File(state.pickedImage));
                                  }
                                }
                                if (state is PickImageError) {
                                  return Center(
                                    child: Text("Error"),
                                  );
                                }
                                if (state is ProductPickLoading) {
                                  return Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                }
                                return Image.network(
                                  fit: BoxFit.cover,
                                  widget.productData.image!,
                                );
                              },
                            )),
                          ),
                          Positioned(
                              right: 6,
                              bottom: 6,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 25,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      controller: productCode,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: "Kode Produk",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameC,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: "Nama",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceC,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        String rawValue =
                            value.replaceAll(RegExp(r'[^\d]'), '');
                        int parsedValue = int.tryParse(rawValue) ?? 0;
                        priceC.value = TextEditingValue(
                          text: rupiahConverter(parsedValue),
                          selection: TextSelection.collapsed(
                              offset: rupiahConverter(parsedValue).length),
                        );
                      },
                      decoration: InputDecoration(
                        labelText: "Harga",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      child: Text("Simpan"),
                      onPressed: () {
                        context.read<ProductBloc>().add(ProductEditRequested(
                              id: widget.productData.id!,
                              newName: nameC.text,
                              newPrice: priceC.text,
                              publicId: widget.productData.publicId ?? "",
                            ));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
