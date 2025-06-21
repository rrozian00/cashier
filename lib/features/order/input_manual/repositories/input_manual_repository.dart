import 'package:cashier/features/order/order/models/cart_model.dart';
import 'package:cashier/features/product/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/get_user_data.dart';
import '../../../store/repositories/store_repository.dart';
import '../../order/models/order_model.dart';

class InputManualRepository {
  final _firestore = FirebaseFirestore.instance;
  final storeRepo = StoreRepository();

  Future<void> inputManual(
    String total,
    DateTime date,
  ) async {
    try {
      final user = await getUserData();
      if (user == null) return;

      final storeActive = await storeRepo.getActiveStore(user.id!);
      if (storeActive != null) {
        final docRef = _firestore
            .collection("stores")
            .doc(storeActive.id)
            .collection('orders')
            .doc();
        final createdAt = Timestamp.fromDate(date);

        final product = CartModel(
            product: ProductModel(name: "Input Manual", price: total));

        final data = OrderModel(
          name: "Input Manual",
          id: docRef.id,
          total: total,
          products: [product],
          createdAt: createdAt,
        );
        docRef.set(data.toMap());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
