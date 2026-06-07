import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../product/models/product_model.dart';
import '../../../store/repositories/store_repository.dart';
import '../../../user/repositories/user_repository.dart';
import '../../order/models/cart_model.dart';
import '../../order/models/order_model.dart';

class InputManualRepository {
  // final _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;
  final storeRepo = StoreRepository();
  final userRepo = UserRepository();

  Future<void> inputManual(
    int total,
    DateTime date,
  ) async {
    try {
      final user = await userRepo
          .getUserDataFromSupabase()
          .then((e) => e.fold((l) => null, (r) => r));
      if (user == null) return;

      final storeActive = await storeRepo
          .getActiveStore(user.id!)
          .then((e) => e.fold((l) => null, (r) => r));
      if (storeActive != null) {
        // final docRef = _firestore
        //     .collection("stores")
        //     .doc(storeActive.id)
        //     .collection('orders')
        //     .doc();

        final product = CartModel(
            product: ProductModel(name: "Input Manual", price: total));

        final data = OrderModel(
          name: "Input Manual",
          total: total,
          products: [product],
          createdAt: DateTime.now(),
        );
        await _supabase
            .from('orders')
            .insert(data.toMap())
            .eq('store_id', storeActive.id!);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
