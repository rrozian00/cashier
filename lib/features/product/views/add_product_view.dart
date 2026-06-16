import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/my_snackbar.dart';
import '../../../core/utils/rupiah_converter.dart';
import '../../../core/widgets/image_picker_field.dart'; // Import Custom Widget
import '../../scanner/views/scanner_view.dart';
import '../blocs/product_bloc.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
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

  // Local State UI
  File? _selectedImage; // Menampung file hasil callback ImagePickerField
  String? _selectedCategory;

  DateTime _registerDateTime = DateTime.now();
  DateTime _expiredDateTime = DateTime.now();

  @override
  void dispose() {
    categoryController.dispose();
    registeredDateController.dispose();
    expiredDateController.dispose();
    nameController.dispose();
    productCodeController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          // Pola Unified State: Sukses Add otomatis memicu ProductSuccess (Refresh List)
          if (state is ProductSuccess) {
            Navigator.pop(context);
            mySnackbar(context, "Produk berhasil ditambahkan");
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 🔹 PENERAPAN BEST PRACTICE: Menggunakan Reusable Custom Widget
                    Center(
                      child: ImagePickerField(
                        onImageSelected: (file) {
                          // Ambil file yang dipilih dari dalam widget custom
                          _selectedImage = file;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Product Code Field with Scanner
                    _buildProductCodeField(),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),

                    // Date Fields (Conditional for Member)
                    _buildDateFields(),
                    const SizedBox(height: 16),

                    // Name Field
                    _buildNameField(),
                    const SizedBox(height: 16),

                    // Price Field
                    _buildPriceField(),
                    const SizedBox(height: 24),

                    // Submit Button
                    _buildSubmitButton(isLoading),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCodeField() {
    return TextFormField(
      controller: productCodeController,
      validator: (value) =>
          value?.isEmpty ?? true ? "Kode produk wajib diisi" : null,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: "Kode Produk",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScannerView()),
            );
            if (result != null && result is List && result.isNotEmpty) {
              productCodeController.text = result.first.toString();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
          categoryController.text = value ?? '';
        });
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

  Widget _buildDateFields() {
    if (_selectedCategory != "Member") return const SizedBox();

    return Column(
      children: [
        _buildDateField(
          controller: registeredDateController,
          label: "Tanggal Mulai",
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          onDateSelected: (date) => _registerDateTime = date,
        ),
        const SizedBox(height: 12),
        _buildDateField(
          controller: expiredDateController,
          label: "Tanggal Selesai",
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
          onDateSelected: (date) => _expiredDateTime = date,
        ),
      ],
    );
  }

  Widget _buildDateField({
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

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  context.read<ProductBloc>().add(ProductAddRequested(
                        registeredDate: _registerDateTime,
                        expiredDate: _expiredDateTime,
                        category: categoryController.text,
                        name: nameController.text,
                        productCode: productCodeController.text,
                        imageFile:
                            _selectedImage, // Berhasil dikirim ke BLoC tanpa perantara state BLoC
                        price: int.parse(priceController.text
                            .replaceAll(RegExp(r'[^\d]'), '')),
                      ));
                }
              },
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : const Text("SIMPAN", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
