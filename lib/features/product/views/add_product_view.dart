import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../../../core/utils/rupiah_converter.dart';
import '../../../core/utils/scanner_page.dart';
import '../bloc/product_bloc.dart';

class AddProductView extends StatelessWidget {
  AddProductView({super.key});

  final TextEditingController name = TextEditingController();
  final TextEditingController productCode = TextEditingController();
  final TextEditingController image = TextEditingController();
  final TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Produk"),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAddSuccess) {
            Navigator.pop(context);
            context.read<ProductBloc>().add(ProductGetRequested());
          }
          if (state is ProductFailed) {
            debugPrint(state.message);
            Get.snackbar("Error", state.message);
          }
        },
        builder: (context, state) {
          if (state is ProductAddLoading) {
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
                    onTap: () {
                      context.read<ProductBloc>().add(ProductPickImageReq());
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: grey.withAlpha(100),
                          ),
                          height: 200,
                          width: 200,
                          child: ClipOval(
                            child: BlocBuilder<ProductBloc, ProductState>(
                              builder: (context, state) {
                                if (state is ProductPickLoading) {
                                  return Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }
                                if (state is PickImageSuccess) {
                                  image.text = state.pickedImage;
                                  return Image.file(
                                    File(state.pickedImage),
                                    fit: BoxFit.cover,
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                            right: 6,
                            bottom: 6,
                            child: Icon(
                              Icons.change_circle,
                              size: 50,
                              color: purple,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                      ),
                      IconButton(
                        onPressed: () async {
                          String? hasilScan = await Get.to(ScannerPage());
                          if (hasilScan != null) {
                            productCode.text = hasilScan;
                          }
                        },
                        icon: Icon(Icons.qr_code_scanner),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (value) => name.text = value,
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
                      int parsedValue = int.tryParse(rawValue) ?? 0;
                      price.value = TextEditingValue(
                        text: rupiahConverter(parsedValue),
                        selection: TextSelection.collapsed(
                            offset: rupiahConverter(parsedValue).length),
                      );
                    },
                    decoration: InputDecoration(
                      labelText: "Harga",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                      // width: MediaQuery.of(context).size.width * 0.9,
                      // text: "Simpan",
                      child: Text("Simpan"),
                      onPressed: () {
                        context.read<ProductBloc>().add(ProductAddRequested(
                              name: name.text,
                              productCode: productCode.text,
                              price: price.text
                                  .replaceAll('.', '')
                                  .replaceAll('Rp ', ''),
                              image: image.text,
                            ));
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
