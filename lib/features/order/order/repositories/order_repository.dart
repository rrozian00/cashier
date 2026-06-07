import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/app_errors/failure.dart';
import '../../../store/repositories/store_repository.dart';
import '../../../user/repositories/user_repository.dart';
import '../models/order_model.dart';

class OrderRepository {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;
  final storeRepo = StoreRepository();
  final userRepo = UserRepository();

  Future<Either<Failure, List<OrderModel>>> getHistoryOrders(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final user = await userRepo
          .getUserDataFromSupabase()
          .then((e) => e.fold((l) => null, (r) => r));
      if (user == null) return Left(Failure("User tidak ditemukan"));
      final store = await storeRepo
          .getActiveStore(user.id!)
          .then((e) => e.fold((l) => null, (r) => r));
      if (store == null) return Left(Failure("Store tidak ditemukan"));

      final data = await _supabase
          .from('orders')
          .select()
          .eq('store_id', store.id!)
          .gte('created_at', start.toIso8601String())
          .lte('created_at', end.toIso8601String())
          .then((value) => value.map((e) => OrderModel.fromMap(e)).toList());

      return Right(data);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> saveOrder(OrderModel order) async {
    try {
      final user = await userRepo
          .getUserDataFromSupabase()
          .then((e) => e.fold((l) => null, (r) => r));
      if (user == null) {
        return Left(Failure("User tidak ditemukan"));
      }

      final storeData = await storeRepo
          .getActiveStore(user.id!)
          .then((e) => e.fold((l) => null, (r) => r));

      if (storeData == null) {
        return Left(Failure("Store Data tidak ditemukan"));
      }

      await _supabase.from('orders').insert(order.toMap());
      print("order saved");
      return Right(null);
    } catch (e) {
      print(e);
      return Left(Failure("error: $e"));
    }
  }
}
