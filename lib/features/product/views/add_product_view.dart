import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Obx(
                        () => CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              controller.selectedImage.value != null
                                  ? FileImage(
                                      controller.selectedImage.value!,
                                    )
                                  : null,
                          child: controller.selectedImage.value == null
                              ? const Icon(Icons.add_a_photo)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.productCodeController,
                      decoration: const InputDecoration(
                        labelText: "Kode Produk",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Kode produk wajib";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: controller.selectedCategory.value.isEmpty
                          ? null
                          : controller.selectedCategory.value,
                      items: controller.categoryList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controller.changeCategory(value ?? "");
                      },
                      decoration: const InputDecoration(
                        labelText: "Kategori",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => controller.selectedCategory.value == "Member"
                          ? Column(
                              children: [
                                TextFormField(
                                  controller:
                                      controller.registeredDateController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: "Tanggal Mulai",
                                  ),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );

                                    if (date != null) {
                                      controller.registerDate = date;

                                      controller.registeredDateController.text =
                                          DateFormat(
                                        'dd-MM-yyyy',
                                      ).format(date);
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            )
                          : const SizedBox(),
                    ),
                    TextFormField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: "Nama Produk",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Harga",
                      ),
                      onChanged: (value) {
                        final numericValue =
                            value.replaceAll(RegExp(r'[^\d]'), '');

                        final parsedValue = int.tryParse(numericValue) ?? 0;

                        controller.priceController.value = TextEditingValue(
                          text: rupiahConverter(parsedValue),
                          selection: TextSelection.collapsed(
                            offset: rupiahConverter(parsedValue).length,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.addProduct,
                        child: const Text("SIMPAN"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
