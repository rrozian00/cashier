import 'package:cashier/core/app_errors/failure.dart';
import 'package:cashier/features/order/order/models/order_model.dart';
import 'package:cashier/features/store/repositories/store_repository.dart';
import 'package:cashier/features/user/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryOrderRepository {
  final SupabaseClient _supabase;
  final UserRepository userRepo;
  final StoreRepository storeRepo;

  HistoryOrderRepository(this._supabase, this.userRepo, this.storeRepo);

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
          .order('created_at', ascending: false)
          .then((value) => value.map((e) => OrderModel.fromMap(e)).toList());

      return Right(data);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
