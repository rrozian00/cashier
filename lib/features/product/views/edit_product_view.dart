import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/my_snackbar.dart';
import '../../../core/utils/rupiah_converter.dart';
import '../../../core/widgets/image_picker_field.dart'; // Import Custom Widget
import '../blocs/product_bloc.dart';
import '../models/product_model.dart';

class EditProductView extends StatefulWidget {
  final ProductModel productData;

  const EditProductView({super.key, required this.productData});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  late final TextEditingController productCode;
  late final TextEditingController nameC;
  late final TextEditingController priceC;

  // Local State untuk menampung file baru dari callback (Best Practice)
  File? _newSelectedImage;

  @override
  void initState() {
    super.initState();
    productCode = TextEditingController(text: widget.productData.id ?? '');
    nameC = TextEditingController(text: widget.productData.name ?? '');
    priceC = TextEditingController(
        text: rupiahConverter(widget.productData.price ?? 0));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          // Pola Unified State: Sukses Edit otomatis kembali ke ProductSuccess (Refresh List)
          if (state is ProductSuccess) {
            Navigator.pop(context);
            mySnackbar(context, "Produk berhasil diperbarui");
          }
          if (state is ProductFailed) {
            mySnackbar(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state is ProductLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 🔹 PENERAPAN BEST PRACTICE: Menggunakan Reusable Custom Widget
                  Center(
                    child: ImagePickerField(
                      // Tampilkan gambar lama yang sudah tersimpan di cloud
                      initialImageUrl: widget.productData.image,
                      onImageSelected: (file) {
                        // Tangkap file baru jika user mengubah gambar
                        _newSelectedImage = file;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product Code Field (Read Only)
                  TextField(
                    readOnly: true,
                    controller: productCode,
                    decoration: InputDecoration(
                      labelText: "Kode Produk",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name Field
                  TextField(
                    controller: nameC,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Nama Produk",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price Field
                  TextField(
                    controller: priceC,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
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
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (nameC.text.trim().isEmpty ||
                                  priceC.text.isEmpty) {
                                mySnackbar(
                                    context, "Nama dan Harga wajib diisi",
                                    isError: true);
                                return;
                              }

                              context
                                  .read<ProductBloc>()
                                  .add(ProductEditRequested(
                                    id: widget.productData.id!,
                                    newName: nameC.text,
                                    newPrice: int.parse(priceC.text
                                        .replaceAll(RegExp(r'[^\d]'), '')),
                                    newImage:
                                        _newSelectedImage, // Passing file lokal hasil picking (bisa null jika gambar tak diganti)
                                    publicId: widget.productData.publicId ?? "",
                                  ));
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Simpan Perubahan",
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
