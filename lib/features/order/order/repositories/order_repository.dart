import 'package:cashier/core/utils/get_user_data.dart';
import 'package:cashier/features/store/repositories/store_repository.dart';

import '../../../../core/app_errors/failure.dart';

import '../models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storeRepo = StoreRepository();

  Future<Either<Failure, List<OrderModel>>> getHistoryOrders(
    Timestamp start,
    Timestamp end,
  ) async {
    try {
      final user = await getUserData();
      if (user == null) return Left(Failure("User tidak ditemukan"));
      final store = await storeRepo.getActiveStore(user.id!);
      if (store == null) return Left(Failure("Store tidak ditemukan"));
      final result = await _firestore
          .collection("stores")
          .doc(store.id)
          .collection("orders")
          .where("createdAt", isGreaterThanOrEqualTo: start)
          .where("createdAt", isLessThan: end)
          .get();
      final data = result.docs
          .map(
            (e) => OrderModel.fromMap(e.data()),
          )
          .toList();
      return Right(data);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> saveOrder(OrderModel orderModel) async {
    try {
      final user = await getUserData();
      if (user == null) {
        return Left(Failure("User tidak ditemukan"));
      }
      if (user.role == 'owner') {
        final storeData = await storeRepo.getActiveStore(user.id!);

        if (storeData == null) {
          return Left(Failure("Store Data tidak ditemukan"));
        }

        final storeId = storeData.id;
        final docRef = _firestore
            .collection('stores')
            .doc(storeId)
            .collection('orders')
            .doc();
        final data = orderModel.copyWith(id: docRef.id);
        await docRef.set(data.toMap());
        return Right(null);
      } else {
        final storeResult = await storeRepo.getStoreAsEmployee(user.id!);
        storeResult.fold(
          (err) {
            return Left(Failure(err.message));
          },
          (store) async {
            final storeId = store.id;
            final docRef = _firestore
                .collection('stores')
                .doc(storeId)
                .collection('orders')
                .doc();
            final data = orderModel.copyWith(id: docRef.id);
            await docRef.set(data.toMap());
            return Right(null);
          },
        );
      }
      return Left(Failure("Unexpected error "));
    } catch (e) {
      return Left(Failure("error: $e"));
    }
  }
}
