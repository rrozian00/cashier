import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../models/store_model.dart';

class StoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, StoreModel>> getStore(String storeId) async {
    try {
      final storeDoc = await _firestore.collection("stores").doc(storeId).get();
      if (storeDoc.exists && storeDoc.data() != null) {
        final store = StoreModel.fromMap(storeDoc.data()!);
        return Right(store);
      }
      return Left(Failure('Store with ID $storeId not found.'));
    } catch (e) {
      return Left(Failure("Unexpected error ${e.toString()}"));
    }
  }
}
