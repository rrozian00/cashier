import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_errors/failure.dart';
import '../models/user_model.dart';
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
      // debugPrint("Error login: ${e.code}");
      return Left(Failure(e.code!));
    }
    return Left(Failure("Unexpected error"));
  }

  Future<Either<Failure, void>> createUserToSupabase(
      UserModel user, String password) async {
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

        await _supabase.client.from('users').insert(data.toMap());

        return Right(null);
      } else if (res.session == null) {
        return Left(Failure("Failed to create user: No session returned"));
      }
    } catch (e) {
      return Left(Failure("Failed to create user: ${e.toString()}"));
    }
    return Left(Failure("Failed to create user"));
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
    if (user == null) throw Exception("User tidak ditemukan di Firestore");

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

  Future<Either<Failure, UserModel>> getUserDataFromSupabase() async {
    final Supabase supabase = Supabase.instance;
    final id = supabase.client.auth.currentUser?.id;
    if (id == null) {
      return Left(Failure("User not authenticated"));
    }

    try {
      final user =
          await supabase.client.from('users').select().eq('id', id).single();
      return Right(UserModel.fromMap(user));
    } catch (e) {
      return Left(Failure('Failed to fetch user data'));
    }
  }
}
