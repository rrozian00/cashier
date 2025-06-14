import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Supabase _supabase = Supabase.instance;

  Future<Either<Failure, User?>> login(String email, String password) async {
    try {
      final res = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      if (res.user != null) {
        return Right(res.user);
      }
    } on AuthApiException catch (e) {
      print(e);
      return Left(Failure(e.code!));
    }
    return Left(Failure("ubex error"));
  }

  Future<void> createUser(UserModel user, String password) async {
    // final userCredential = await _auth.createUserWithEmailAndPassword(
    //     email: user.email!, password: password);

    try {
      //Supabase
      final res = await _supabase.client.auth.signUp(
        email: user.email,
        password: password,
      );
      if (res.user != null) {
        final data = UserModel(
            // id: userCredential.user?.uid,
            id: res.user?.id,
            storeId: user.storeId,
            email: user.email,
            name: user.name,
            address: user.address,
            salary: user.salary,
            role: "owner",
            phoneNumber: user.phoneNumber,
            photo: user.photo,
            createdAt: user.createdAt);

        await _firestore.collection("users").doc(data.id).set(data.toMap());
        print("Register berhasil, ${res.user!.email}");
      } else if (res.session == null) {
        print("Perlu verifikasi email");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editUser({
    required String id,
    required String newName,
    required String newAddress,
    required String newPhone,
    required String newSalary,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(id)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        );
    final docSnap = await docRef.get();
    final user = docSnap.data();
    if (user == null) throw Exception("User tidak ditemukan di Firestore");

    final updateUser = user.copyWith(
      name: newName,
      address: newAddress,
      phoneNumber: newPhone,
      salary: newSalary,
    );

    await docRef.set(updateUser);
  }

  Future<Either<Failure, UserModel>> getUser(String uid) async {
    try {
      final doc = await _firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        final user = UserModel.fromMap(doc.data()!);
        return Right(user);
      }
      return Left(Failure("User with ID $uid not found"));
    } catch (e) {
      return Left(Failure("Unexpected error ${e.toString()}"));
    }
  }
}
