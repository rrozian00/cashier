import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_errors/failure.dart';
import '../../user/repositories/user_repository.dart';
import '../models/store_model.dart';

class StoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;
  final userRepository = UserRepository();

  Future<Either<Failure, List<StoreModel>>> getStore(String id) async {
    try {
      final store = await _supabase.from('stores').select().eq('owner_id', id);

      return Right(store.map((e) => StoreModel.fromMap(e)).toList());
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
    required String ownerId,
    required String name,
    required String address,
    required String phone,
    required String logoUrl,
  }) async {
    try {
      final store = StoreModel(
        isActive: false,
        ownerId: ownerId,
        name: name,
        address: address,
        phone: phone,
        logoUrl: logoUrl,
        createdAt: DateTime.now(),
      );

      await _supabase.from('stores').insert(store.toMap());
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Either<Failure, void>> activateStore(String id) async {
    try {
      await _supabase.from('stores').update({"is_active": true}).eq('id', id);
      return Right(null);
    } catch (e) {
      return Left(Failure("Error: ${e.toString()}"));
    }
  }

  Future<void> updateStore({
    required StoreModel store,
    required String name,
    required String address,
    required String phone,
  }) async {
    try {
      final newData = store.copyWith(
        name: name,
        address: address,
        phone: phone,
      );

      await _supabase
          .from('stores')
          .update(newData.toMap())
          .eq('id', store.id!);
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }
}
