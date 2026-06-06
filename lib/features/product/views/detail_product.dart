import 'package:flutter/material.dart';

import '../../../core/utils/rupiah_converter.dart';
import '../models/product_model.dart';

class DetailProduct extends StatelessWidget {
  const DetailProduct({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Product"),
      ),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
                tag: "product-${product.id}",
                child: ClipOval(child: Image.network(product.image ?? ''))),
            Text(
              product.name ?? '',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              rupiahConverter(product.price ?? 0),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 45),
            ),
          ],
        ),
      )),
    );
  }
}
