import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../../../core/utils/scanner_page.dart';
import '../bloc/product_bloc.dart';

class AddProductView extends StatelessWidget {
  AddProductView({super.key});

  final List<String> categoryList = [
    "Member",
    "Produk",
  ];

  final TextEditingController category = TextEditingController();
  final TextEditingController registeredDate = TextEditingController();
  final TextEditingController expiredDate = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController productCode = TextEditingController();
  final TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime registerDateTime = DateTime.now();
    DateTime expiredDateTime = DateTime.now();

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
          if (state is PickImageError) {
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
                spacing: 10,
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
                            color: Colors.grey.withAlpha(100),
                          ),
                          height: 80,
                          width: 80,
                          child: ClipOval(
                            child: BlocBuilder<ProductBloc, ProductState>(
                              builder: (context, state) {
                                if (state is ProductPickLoading) {
                                  return Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }
                                if (state is PickImageSuccess) {
                                  return Image.file(
                                    File(state.pickedImage),
                                    fit: BoxFit.cover,
                                  );
                                }
                                if (state is PickImageError) {
                                  return Center(
                                      child: Text(
                                    "Error",
                                    style: TextStyle(color: Colors.red),
                                  ));
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
                              Icons.add_a_photo,
                              size: 25,
                            ))
                      ],
                    ),
                  ),

                  //barcode
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

                  // Kategori Produk
                  DropdownButtonFormField(
                    onChanged: (value) {
                      value = category.text;
                      context
                          .read<ProductBloc>()
                          .add(ProductCategoryChanged(category: value));
                    },
                    items: categoryList.map((e) {
                      return DropdownMenuItem<String>(
                        onTap: () {
                          category.text = e;
                        },
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Kategori tidak boleh kosong.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori",
                      hintText: "Kategori",
                    ),
                  ),

                  //📅 tanggal daftar & expired
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductCategoryUpdated &&
                          state.category == "Member") {
                        return Column(
                          spacing: 10,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: registeredDate,
                                  decoration: InputDecoration(
                                      labelText: "Tanggal Mulai"),
                                )),
                                IconButton(
                                    onPressed: () async {
                                      final dateFormat =
                                          DateFormat('dd-MM-yyyy');
                                      final dateResult = await showDatePicker(
                                          fieldLabelText: "Pilih",
                                          confirmText: "Simpan",
                                          cancelText: "Batal",
                                          context: context,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime.now());
                                      if (dateResult != null) {
                                        final date =
                                            dateFormat.format(dateResult);
                                        registeredDate.text = date;
                                        registerDateTime = dateResult;
                                      }
                                    },
                                    icon: Icon(Icons.date_range)),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: expiredDate,
                                  decoration: InputDecoration(
                                      labelText: "Tanggal Selesai"),
                                )),
                                IconButton(
                                    onPressed: () async {
                                      final dateFormat =
                                          DateFormat('dd-MM-yyyy');
                                      final dateResult = await showDatePicker(
                                          confirmText: "Simpan",
                                          cancelText: "Batal",
                                          context: context,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2030));
                                      if (dateResult != null) {
                                        final date =
                                            dateFormat.format(dateResult);
                                        expiredDate.text = date;
                                        expiredDateTime = dateResult;
                                      }
                                    },
                                    icon: Icon(Icons.date_range)),
                              ],
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),

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
                              registeredDate: registerDateTime,
                              expiredDate: expiredDateTime,
                              category: category.text,
                              name: name.text,
                              productCode: productCode.text,
                              price: price.text
                                  .replaceAll('.', '')
                                  .replaceAll('Rp ', ''),
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
