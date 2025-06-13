import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/failure.dart';
import '../models/store_model.dart';

class StoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Future<Either<Failure, List<StoreModel>>> getStore(String ownerId) async {
    try {
      final storeDoc = await _firestore
          .collection("stores")
          .where("ownerId", isEqualTo: ownerId)
          .get();

      if (storeDoc.docs.isNotEmpty) {
        final store = storeDoc.docs
            .map(
              (e) => StoreModel.fromMap(e.data()),
            )
            .toList();
        return Right(store);
      }
      return Left(Failure('Store with ID $ownerId not found.'));
    } catch (e) {
      return Left(Failure("Unexpected error ${e.toString()}"));
    }
  }

  Future<void> addStore({
    required String name,
    required String address,
    required String phone,
    required String logoUrl,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (_auth.currentUser == null) return;

      final docRef = _firestore.collection("stores").doc();

      final store = StoreModel(
        id: docRef.id,
        ownerId: uid,
        name: name,
        address: address,
        phone: phone,
        logoUrl: logoUrl,
        createdAt: Timestamp.now(),
      );

      await docRef.set(store.toMap());
    } catch (e) {
      throw Exception("Unexpected error : $e");
    }
  }
}
