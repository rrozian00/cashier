import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/my_text_field.dart';
import '../controllers/add_store_controller.dart';

class AddStoreView extends GetView<AddStoreController> {
  AddStoreView({super.key});

  final name = TextEditingController();
  final category = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();
  final logoUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Toko")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Toko
              MyTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama Toko tidak boleh kosong.";
                  }
                  return null;
                },
                hint: "Nama Toko",
                label: "Nama Toko",
                controller: name,
              ),

              // Alamat
              MyTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Alamat Toko tidak boleh kosong.";
                  }
                  return null;
                },
                controller: address,
                label: "Alamat",
                hint: "Alamat",
              ),

              // Nomor HP
              MyTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "No HP Toko tidak boleh kosong.";
                  }
                  return null;
                },
                label: "No HP",
                hint: "No HP",
                controller: phone,
                textInputType: TextInputType.phone,
              ),

              // Logo URL
              MyTextField(
                label: "Logo",
                hint: "Logo",
                controller: logoUrl,
              ),

              // Tombol Simpan
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   context.read<StoreBloc>().add(AddStore(
                      //       category: category.text,
                      //       name: name.text,
                      //       address: address.text,
                      //       phone: phone.text,
                      //       logoUrl: logoUrl.text));
                      // }
                    },
                    child: Text("Simpan"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
