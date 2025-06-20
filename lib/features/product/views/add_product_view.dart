// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../../core/utils/rupiah_converter.dart';
// import '../../../core/utils/scanner_page.dart';
// import '../blocs/product_bloc/product_bloc.dart';

// class AddProductView extends StatelessWidget {
//   AddProductView({super.key});

//   final _formKey = GlobalKey<FormState>();

//   final List<String> categoryList = [
//     "Member",
//     "Produk",
//   ];

//   final TextEditingController category = TextEditingController();
//   final TextEditingController registeredDate = TextEditingController();
//   final TextEditingController expiredDate = TextEditingController();
//   final TextEditingController name = TextEditingController();
//   final TextEditingController productCode = TextEditingController();
//   final TextEditingController price = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     DateTime registerDateTime = DateTime.now();
//     DateTime expiredDateTime = DateTime.now();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Tambah Produk"),
//       ),
//       body: BlocConsumer<ProductBloc, ProductState>(
//         listener: (context, state) {
//           if (state is ProductAddSuccess) {
//             Navigator.pop(context);
//             context.read<ProductBloc>().add(ProductGetRequested());
//           }
//           if (state is PickImageError) {
//             debugPrint(state.message);
//             Get.snackbar("Error", state.message);
//           }
//         },
//         builder: (context, state) {
//           if (state is ProductAddLoading) {
//             return Center(
//               child: CircularProgressIndicator.adaptive(),
//             );
//           }
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   spacing: 10,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         context.read<ProductBloc>().add(ProductPickImageReq());
//                       },
//                       child: Stack(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.grey.withAlpha(100),
//                             ),
//                             height: 80,
//                             width: 80,
//                             child: ClipOval(
//                               child: BlocBuilder<ProductBloc, ProductState>(
//                                 builder: (context, state) {
//                                   if (state is ProductPickLoading) {
//                                     return Center(
//                                       child:
//                                           CircularProgressIndicator.adaptive(),
//                                     );
//                                   }
//                                   if (state is PickImageSuccess) {
//                                     return Image.file(
//                                       File(state.pickedImage),
//                                       fit: BoxFit.cover,
//                                     );
//                                   }
//                                   if (state is PickImageError) {
//                                     return Center(
//                                         child: Text(
//                                       "Error",
//                                       style: TextStyle(color: Colors.red),
//                                     ));
//                                   }
//                                   return Container();
//                                 },
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                               right: 6,
//                               bottom: 6,
//                               child: Icon(
//                                 Icons.add_a_photo,
//                                 size: 25,
//                               ))
//                         ],
//                       ),
//                     ),

//                     //barcode
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Kode produk tidak boleh kosong.";
//                               }
//                               return null;
//                             },
//                             controller: productCode,
//                             textInputAction: TextInputAction.next,
//                             textCapitalization: TextCapitalization.characters,
//                             decoration: InputDecoration(
//                               labelText: "Kode Produk",
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () async {
//                             String? hasilScan = await Get.to(ScannerPage());
//                             if (hasilScan != null) {
//                               productCode.text = hasilScan;
//                             }
//                           },
//                           icon: Icon(Icons.qr_code_scanner),
//                         )
//                       ],
//                     ),

//                     // Kategori Produk
//                     DropdownButtonFormField(
//                       onChanged: (value) {
//                         value = category.text;
//                         context
//                             .read<ProductBloc>()
//                             .add(ProductCategoryChanged(category: value));
//                       },
//                       items: categoryList.map((e) {
//                         return DropdownMenuItem<String>(
//                           onTap: () {
//                             category.text = e;
//                           },
//                           value: e,
//                           child: Text(e),
//                         );
//                       }).toList(),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Kategori tidak boleh kosong.";
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         labelText: "Kategori",
//                         hintText: "Kategori",
//                       ),
//                     ),

//                     //📅 tanggal daftar & expired
//                     BlocBuilder<ProductBloc, ProductState>(
//                       builder: (context, state) {
//                         if (state is ProductCategoryUpdated &&
//                             state.category == "Member") {
//                           return Column(
//                             spacing: 10,
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                       child: TextField(
//                                     readOnly: true,
//                                     controller: registeredDate,
//                                     decoration: InputDecoration(
//                                         labelText: "Tanggal Mulai"),
//                                   )),
//                                   IconButton(
//                                       onPressed: () async {
//                                         final dateFormat =
//                                             DateFormat('dd-MM-yyyy');
//                                         final dateResult = await showDatePicker(
//                                             fieldLabelText: "Pilih",
//                                             confirmText: "Simpan",
//                                             cancelText: "Batal",
//                                             context: context,
//                                             firstDate: DateTime(2020),
//                                             lastDate: DateTime.now());
//                                         if (dateResult != null) {
//                                           final date =
//                                               dateFormat.format(dateResult);
//                                           registeredDate.text = date;
//                                           registerDateTime = dateResult;
//                                         }
//                                       },
//                                       icon: Icon(Icons.date_range)),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                       child: TextField(
//                                     readOnly: true,
//                                     controller: expiredDate,
//                                     decoration: InputDecoration(
//                                         labelText: "Tanggal Selesai"),
//                                   )),
//                                   IconButton(
//                                       onPressed: () async {
//                                         final dateFormat =
//                                             DateFormat('dd-MM-yyyy');
//                                         final dateResult = await showDatePicker(
//                                             confirmText: "Simpan",
//                                             cancelText: "Batal",
//                                             context: context,
//                                             firstDate: DateTime.now(),
//                                             lastDate: DateTime(2030));
//                                         if (dateResult != null) {
//                                           final date =
//                                               dateFormat.format(dateResult);
//                                           expiredDate.text = date;
//                                           expiredDateTime = dateResult;
//                                         }
//                                       },
//                                       icon: Icon(Icons.date_range)),
//                                 ],
//                               ),
//                             ],
//                           );
//                         }
//                         return Container();
//                       },
//                     ),

//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Nama tidak boleh kosong.";
//                         }
//                         return null;
//                       },
//                       controller: name,
//                       textInputAction: TextInputAction.next,
//                       textCapitalization: TextCapitalization.characters,
//                       onChanged: (value) => name.text = value,
//                       decoration: InputDecoration(
//                         labelText: "Nama",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                     ),

//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Harga tidak boleh kosong.";
//                         }
//                         return null;
//                       },
//                       controller: price,
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         String rawValue =
//                             value.replaceAll(RegExp(r'[^\d]'), '');
//                         int parsedValue = int.tryParse(rawValue) ?? 0;
//                         price.value = TextEditingValue(
//                           text: rupiahConverter(parsedValue),
//                           selection: TextSelection.collapsed(
//                               offset: rupiahConverter(parsedValue).length),
//                         );
//                       },
//                       decoration: InputDecoration(
//                         labelText: "Harga",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 25),
//                     ElevatedButton(
//                         // width: MediaQuery.of(context).size.width * 0.9,
//                         // text: "Simpan",
//                         child: Text("Simpan"),
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             context.read<ProductBloc>().add(ProductAddRequested(
//                                   registeredDate: registerDateTime,
//                                   expiredDate: expiredDateTime,
//                                   category: category.text,
//                                   name: name.text,
//                                   productCode: productCode.text,
//                                   price: price.text
//                                       .replaceAll('.', '')
//                                       .replaceAll('Rp ', ''),
//                                 ));
//                           }
//                         }),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../../../core/utils/scanner_page.dart';
import '../blocs/product_bloc/product_bloc.dart';

class AddProductView extends StatelessWidget {
  AddProductView({super.key});

  final _formKey = GlobalKey<FormState>();
  final List<String> categoryList = ["Member", "Produk"];

  // Controllers
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController registeredDateController =
      TextEditingController();
  final TextEditingController expiredDateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime registerDateTime = DateTime.now();
    DateTime expiredDateTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAddSuccess) {
            Navigator.pop(context);
            context.read<ProductBloc>().add(ProductGetRequested());
            Get.snackbar("Sukses", "Produk berhasil ditambahkan");
          }
          if (state is PickImageError) {
            Get.snackbar("Error", state.message);
          }
        },
        builder: (context, state) {
          if (state is ProductAddLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Image Picker
                    _buildImagePicker(context, state),
                    const SizedBox(height: 20),

                    // Product Code Field with Scanner
                    _buildProductCodeField(context),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    _buildCategoryDropdown(context),
                    const SizedBox(height: 16),

                    // Date Fields (Conditional for Member)
                    _buildDateFields(
                        context, state, registerDateTime, expiredDateTime),
                    const SizedBox(height: 16),

                    // Name Field
                    _buildNameField(),
                    const SizedBox(height: 16),

                    // Price Field
                    _buildPriceField(),
                    const SizedBox(height: 24),

                    // Submit Button
                    _buildSubmitButton(
                        context, registerDateTime, expiredDateTime),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, ProductState state) {
    return GestureDetector(
      onTap: () => context.read<ProductBloc>().add(ProductPickImageReq()),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withAlpha(100),
            ),
            height: 100,
            width: 100,
            child: ClipOval(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductPickLoading) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (state is PickImageSuccess) {
                    return Image.file(File(state.pickedImage),
                        fit: BoxFit.cover);
                  }
                  if (state is PickImageError) {
                    return const Center(
                        child: Icon(Icons.error, color: Colors.red));
                  }
                  return const Center(child: Icon(Icons.add_a_photo, size: 40));
                },
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.edit, size: 20, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductCodeField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: productCodeController,
            validator: (value) =>
                value?.isEmpty ?? true ? "Kode produk wajib diisi" : null,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: "Kode Produk",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () async {
                  final result = await Get.to(() => ScannerPage());
                  if (result != null) productCodeController.text = result;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: categoryController.text.isEmpty ? null : categoryController.text,
      onChanged: (value) {
        categoryController.text = value ?? '';
        context
            .read<ProductBloc>()
            .add(ProductCategoryChanged(category: value ?? ''));
      },
      items: categoryList
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      validator: (value) => value?.isEmpty ?? true ? "Pilih kategori" : null,
      decoration: InputDecoration(
        labelText: "Kategori",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDateFields(
    BuildContext context,
    ProductState state,
    DateTime registerDateTime,
    DateTime expiredDateTime,
  ) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final showDates =
            (state is ProductCategoryUpdated && state.category == "Member") ||
                categoryController.text == "Member";

        if (!showDates) return const SizedBox();

        return Column(
          children: [
            _buildDateField(
              context: context,
              controller: registeredDateController,
              label: "Tanggal Mulai",
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              onDateSelected: (date) => registerDateTime = date,
            ),
            const SizedBox(height: 12),
            _buildDateField(
              context: context,
              controller: expiredDateController,
              label: "Tanggal Selesai",
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
              onDateSelected: (date) => expiredDateTime = date,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime) onDateSelected,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: firstDate,
              lastDate: lastDate,
              helpText: 'Pilih $label',
              cancelText: 'Batal',
              confirmText: 'Pilih',
            );
            if (date != null) {
              controller.text = DateFormat('dd-MM-yyyy').format(date);
              onDateSelected(date);
            }
          },
        ),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? "$label wajib diisi" : null,
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      validator: (value) => value?.isEmpty ?? true ? "Nama wajib diisi" : null,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: "Nama Produk",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: priceController,
      validator: (value) {
        if (value?.isEmpty ?? true) return "Harga wajib diisi";
        final numericValue = value!.replaceAll(RegExp(r'[^\d]'), '');
        if (int.tryParse(numericValue) == null) return "Harga tidak valid";
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Harga",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (value) {
        final numericValue = value.replaceAll(RegExp(r'[^\d]'), '');
        final parsedValue = int.tryParse(numericValue) ?? 0;
        priceController.value = TextEditingValue(
          text: rupiahConverter(parsedValue),
          selection: TextSelection.collapsed(
            offset: rupiahConverter(parsedValue).length,
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    DateTime registerDateTime,
    DateTime expiredDateTime,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<ProductBloc>().add(ProductAddRequested(
                  registeredDate: registerDateTime,
                  expiredDate: expiredDateTime,
                  category: categoryController.text,
                  name: nameController.text,
                  productCode: productCodeController.text,
                  price: priceController.text
                      .replaceAll('.', '')
                      .replaceAll('Rp ', ''),
                ));
          }
        },
        child: const Text("SIMPAN", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
