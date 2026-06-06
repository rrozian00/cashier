import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_errors/failure.dart';
import '../models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Supabase _supabase = Supabase.instance;

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

  Future<Either<Failure, void>> editUser({
    required UserModel user,
    required String newName,
    required String newAddress,
    required String newPhone,
  }) async {
    try {
      final newData = user.copyWith(
        name: newName,
        address: newAddress,
        phoneNumber: newPhone,
      );
      await _supabase.client
          .from('users')
          .update(newData.toMap())
          .eq("id", user.id!);
      return Right(null);
    } catch (e) {
      return Left(Failure("Error: ${e.toString()}"));
    }
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
