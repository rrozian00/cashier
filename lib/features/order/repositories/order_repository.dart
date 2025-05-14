import '../../../core/errors/failure.dart';
import '../../../core/utils/get_store_id.dart';
import '../models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, List<OrderModel>>> getOrders() async {
    try {
      final storeId = await getStoreId();
      final result = await _firestore
          .collection("stores")
          .doc(storeId)
          .collection("orders")
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

  Stream<Either<Failure, List<OrderModel>>> streamOrders() async* {
    try {
      final storeId = await getStoreId();

      yield* _firestore
          .collection("stores")
          .doc(storeId)
          .collection("orders")
          .snapshots()
          .asyncMap(
        (snap) async {
          try {
            final data = snap.docs
                .map(
                  (e) => OrderModel.fromMap(e.data()),
                )
                .toList();
            return Right(data);
          } catch (e) {
            return Left(Failure(e.toString()));
          }
        },
      );
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }
}
