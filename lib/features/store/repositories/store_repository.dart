import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../core/utils/get_user_data.dart';
import '../models/store_model.dart';

class StoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, List<StoreModel>>> getStoreAsOwner(
      String ownerId) async {
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
      return Left(Failure('null'));
    } catch (e) {
      return Left(Failure("Error : ${e.toString()}"));
    }
  }

  Future<Either<Failure, StoreModel>> getStoreAsEmployee(
      String employeeId) async {
    try {
      final storeDoc = await _firestore
          .collection("stores")
          .where("employees", arrayContains: employeeId)
          .get();

      if (storeDoc.docs.isNotEmpty) {
        final store = storeDoc.docs
            .map(
              (e) => StoreModel.fromMap(e.data()),
            )
            .toList();
        return Right(store.first);
      }
      return Left(Failure('null'));
    } catch (e) {
      return Left(Failure("Error : ${e.toString()}"));
    }
  }

  Future<StoreModel?> getActiveStore(String ownerId) async {
    try {
      final store = await _firestore
          .collection("stores")
          .where("ownerId", isEqualTo: ownerId)
          .where("isActive", isEqualTo: true)
          .get()
          .then((value) => value.docs
              .map(
                (e) => StoreModel.fromMap(e.data()),
              )
              .first);
      return store;
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<void> addStore({
    required String name,
    required String address,
    required String phone,
    required String logoUrl,
  }) async {
    try {
      // final uid = _auth.currentUser?.uid;
      final user = await getUserData();
      if (user == null) return;

      final docRef = _firestore.collection("stores").doc();

      final store = StoreModel(
        isActive: false,
        id: docRef.id,
        ownerId: user.id,
        name: name,
        address: address,
        phone: phone,
        logoUrl: logoUrl,
        createdAt: Timestamp.now(),
      );

      await docRef.set(store.toMap());
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> activatedStore(String id) async {
    try {
      final user = await getUserData();
      if (user == null) return;
      final stores = await _firestore
          .collection("stores")
          .where("ownerId", isEqualTo: user.id)
          .where("id", isNotEqualTo: id)
          .get()
          .then(
            (value) => value.docs
                .map(
                  (e) => StoreModel.fromMap(e.data()),
                )
                .toList(),
          );

      for (var store in stores) {
        final ids = store.id;
        await _firestore
            .collection("stores")
            .doc(ids)
            .update({"isActive": false});
      }

      await _firestore.collection("stores").doc(id).update({
        "isActive": true,
      });
    } on FirebaseException catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<void> updateStore({
    required String id,
    required String name,
    required String address,
    required String phone,
  }) async {
    try {
      final old = await _firestore.collection("stores").doc(id).get().then(
            (value) => StoreModel.fromMap(value.data()!),
          );
      final newData = old.copyWith(
        name: name,
        address: address,
        phone: phone,
      );

      await _firestore.collection("stores").doc(id).update(newData.toMap());
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }
}
