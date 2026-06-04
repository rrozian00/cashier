import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/app_errors/failure.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<Failure, UserCredential?>> login(
    String email,
    String password,
  ) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(res);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message ?? "Login gagal"));
    } catch (e) {
      return Left(Failure("Unexpected error: $e"));
    }
  }

  Future<void> createUser(UserModel user, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );

      final data = UserModel(
        id: userCredential.user?.uid,
        storeId: user.storeId,
        email: user.email,
        name: user.name,
        address: user.address,
        salary: user.salary,
        role: "owner",
        phoneNumber: user.phoneNumber,
        photo: user.photo,
        createdAt: user.createdAt,
      );

      await _firestore.collection("users").doc(data.id).set(data.toMap());

      print("Register berhasil, ${user.email}");
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
    } catch (e) {
      print("Error create user: $e");
    }
  }

  Future<void> editUser({
    required String id,
    required String newName,
    required String newAddress,
    required String newPhone,
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

    if (user == null) {
      throw Exception("User tidak ditemukan di Firestore");
    }

    final updateUser = user.copyWith(
      name: newName,
      address: newAddress,
      phoneNumber: newPhone,
    );

    await docRef.update(updateUser.toMap());
  }

  Future<Either<Failure, UserModel>> getUser(String id) async {
    try {
      final doc = await _firestore.collection("users").doc(id).get();

      if (doc.exists) {
        final user = UserModel.fromMap(doc.data()!);
        return Right(user);
      }

      return Left(Failure("User with ID $id not found"));
    } catch (e) {
      return Left(Failure("Unexpected error ${e.toString()}"));
    }
  }

  Future<Either<Failure, UserModel?>> getUserData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final docSnapshot =
        await firestore.collection('users').doc(_auth.currentUser!.uid).get();

    if (docSnapshot.exists) {
      try {
        return Right(UserModel.fromMap(docSnapshot.data()!));
      } catch (e) {
        debugPrint("Error parsing UserModel: $e");
      }
    }
    return Left(Failure("User data not found"));
  }
}
