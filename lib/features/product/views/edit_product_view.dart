import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_product_controller.dart';

class EditProductView extends GetView<EditProductController> {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: controller.pickImage,
                    child: Stack(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withAlpha(100),
                          ),
                          child: ClipOval(
                            child: Obx(
                              () {
                                if (controller.isPickImageLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (controller.selectedImage.value != null) {
                                  return Image.file(
                                    controller.selectedImage.value!,
                                    fit: BoxFit.cover,
                                  );
                                }

                                return Image.network(
                                  controller.product.image ?? "",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 5,
                          bottom: 5,
                          child: Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: controller.productCodeC,
                    decoration: InputDecoration(
                      labelText: "Kode Produk",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.nameC,
                    decoration: InputDecoration(
                      labelText: "Nama Produk",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.priceC,
                    keyboardType: TextInputType.number,
                    onChanged: controller.formatPrice,
                    decoration: InputDecoration(
                      labelText: "Harga",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.saveProduct,
                      child: const Text(
                        "SIMPAN",
                      ),
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
