import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/app_errors/failure.dart';
import '../../../store/repositories/store_repository.dart';
import '../../../user/repositories/user_repository.dart';
import '../models/order_model.dart';

class OrderRepository {
  final SupabaseClient _supabase;
  final StoreRepository storeRepo;
  final UserRepository userRepo;

  OrderRepository(this._supabase, this.storeRepo, this.userRepo);

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
