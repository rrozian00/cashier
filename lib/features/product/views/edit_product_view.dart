import '../../../core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../../../core/widgets/my_appbar.dart';
import '../../../core/widgets/my_elevated.dart';
import '../bloc/product_bloc.dart';
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
  late final TextEditingController imageC;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with product data
    productCode = TextEditingController(text: widget.productData.barcode ?? '');
    nameC = TextEditingController(text: widget.productData.name ?? '');
    priceC = TextEditingController(
        text:
            rupiahConverter(int.tryParse(widget.productData.price ?? '') ?? 0));
    imageC = TextEditingController(text: widget.productData.image ?? '');
  }

  @override
  void dispose() {
    productCode.dispose();
    nameC.dispose();
    priceC.dispose();
    imageC.dispose();
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
      },
      child: Scaffold(
        backgroundColor: softGrey,
        appBar: MyAppBar(
          titleText: "Edit Produk",
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Can not chage product image",
                  style: TextStyle(color: grey),
                ),
                imageC.text.isNotEmpty
                    ? Stack(
                        children: [
                          ClipOval(
                              child: Image.network(
                            fit: BoxFit.cover,
                            imageC.text,
                            height: 200,
                          )),
                        ],
                      )
                    : Container(),
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
                const SizedBox(height: 25),
                myGreenElevated(
                  width: 180,
                  text: "Simpan",
                  onPress: () {
                    context.read<ProductBloc>().add(ProductEditRequested(
                          id: widget.productData.id!,
                          newName: nameC.text,
                          newPrice: priceC.text,
                          newImage: imageC.text,
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
