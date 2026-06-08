import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../product/models/product_model.dart';
import '../../../store/repositories/store_repository.dart';
import '../../../user/repositories/user_repository.dart';
import '../../order/models/order_model.dart';

class InputManualRepository {
  final SupabaseClient _supabase;
  final StoreRepository storeRepo;
  final UserRepository userRepo;

  InputManualRepository(this._supabase, this.storeRepo, this.userRepo);

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

        final product = ProductModel(name: "Input Manual", price: total);

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
