// import 'dart:developer';

// import 'package:cashier/core/errors/failure.dart';
// import 'package:cashier/features/store/models/store_model.dart';
// import 'package:cashier/features/store/repositories/store_repository.dart';
// import 'package:cashier/features/user/models/user_model.dart';
// import 'package:cashier/features/user/repositories/user_repository.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class EmployeeRepo {
//   //TODO:employee auth nya ubah pakai supabase
//   final UserRepository _userRepo = UserRepository();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> createEmployee(UserModel user, String password) async {
//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//           email: user.email!, password: password);

//       final stores = await _firestore
//           .collection("stores")
//           .where("ownerId", isEqualTo: user.id)
//           .where("isActive", isEqualTo: true)
//           .get()
//           .then((value) => value.docs
//               .map(
//                 (e) => StoreModel.fromMap(e.data()),
//               )
//               .toList());
//       final store = stores.first;

//       final data = UserModel(
//           id: userCredential.user?.uid,
//           storeId: store.id,
//           email: user.email,
//           name: user.name,
//           address: user.address,
//           salary: user.salary,
//           role: "employee",
//           phoneNumber: user.phoneNumber,
//           photo: user.photo,
//           createdAt: user.createdAt);

//       final QuerySnapshot<Map<String, dynamic>> userQuery = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: user.email)
//           .get();
//       if (userQuery.docs.isNotEmpty) {
//         throw Exception("Email sudah ada");
//       }

//       if (store.id == null) {
//         throw Exception("Store tidak ditemukan");
//       }
//       await _firestore
//           .collection("users")
//           .doc(userCredential.user?.uid)
//           .set(data.toMap());

//       await _firestore.collection("stores").doc(store.id).update({
//         "employees": FieldValue.arrayUnion([userCredential.user?.uid])
//       });
//     } catch (e) {
//       debugPrint("Error saat membuat karyawan: $e");
//       if (e is FirebaseException) {
//         throw Exception("Firebase Error: ${e.message}");
//       } else {
//         throw Exception("Gagal membuat karyawan: ${e.toString()}");
//       }
//     }
//   }

//   Future<Either<Failure, List<UserModel>>> getEmployees() async {
//     try {
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) {
//         return Left(Failure("User with id $userId not found"));
//       }

//       final userEither = await _userRepo.getUser(userId);

//       final user = userEither.getOrElse(
//         () => throw Exception("Unexpected null user"),
//       );

//       if (user.role == 'owner') {
//         final stores = await _firestore
//             .collection('stores')
//             .where("ownerId", isEqualTo: user.id)
//             .where("isActive", isEqualTo: true)
//             .get()
//             .then((value) => value.docs
//                 .map(
//                   (e) => StoreModel.fromMap(e.data()),
//                 )
//                 .toList());

//         final employeeIds = stores.first.employees;

//         if (employeeIds == null || employeeIds.isEmpty) {
//           return Left(Failure("employee null"));
//         }

//         List<UserModel> employeeDatas = [];

//         for (var employeeId in employeeIds) {
//           final snapshot = await _firestore
//               .collection("users")
//               .where("id", isEqualTo: employeeId)
//               .get();
//           final users =
//               snapshot.docs.map((e) => UserModel.fromMap(e.data())).toList();
//           employeeDatas.addAll(users);
//         }
//         return Right(employeeDatas);
//       }
//     } catch (e, stackTrace) {
//       log('Error caught', error: e, stackTrace: stackTrace);
//     }
//     return Left(Failure("Unexpected error"));
//   }

//   Future<void> deleteEmployee(String id) async {
//     final StoreRepository storeRepository = StoreRepository();

//     try {
//       // Hapus user dari koleksi Firestore
//       await _firestore.collection('users').doc(id).delete();

//       // Ambil user yang sedang login
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) return;

//       // Ambil store aktif
//       final store = await storeRepository.getActiveStore(userId);
//       if (store != null) {
//         await _firestore.collection("stores").doc(store.id).update({
//           "employees": FieldValue.arrayRemove([id]),
//         });
//       }
//     } catch (e) {
//       print("Gagal menghapus employee: $e");
//       rethrow;
//     }
//   }
// }
import 'dart:developer';

import 'package:cashier/core/errors/failure.dart';
import 'package:cashier/features/store/models/store_model.dart';
import 'package:cashier/features/store/repositories/store_repository.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cashier/features/user/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeRepo {
  final UserRepository _userRepo = UserRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createEmployee(UserModel user, String password) async {
    try {
      // 1. Buat akun dengan Supabase
      final res = await _supabase.auth.signUp(
        email: user.email!,
        password: password,
      );

      if (res.user == null) {
        throw Exception("Gagal membuat user. Coba lagi.");
      }

      final userId = res.user!.id;

      // 2. Ambil store aktif milik owner
      final stores = await _firestore
          .collection("stores")
          .where("ownerId", isEqualTo: user.id)
          .where("isActive", isEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => StoreModel.fromMap(e.data())).toList());

      if (stores.isEmpty) throw Exception("Store tidak ditemukan");

      final store = stores.first;

      // 3. Cek apakah email sudah digunakan di Firestore
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();
      if (userQuery.docs.isNotEmpty) {
        throw Exception("Email sudah ada");
      }

      // 4. Simpan data user ke Firestore
      final data = UserModel(
        id: userId,
        storeId: store.id,
        email: user.email,
        name: user.name,
        address: user.address,
        salary: user.salary,
        role: "employee",
        phoneNumber: user.phoneNumber,
        photo: user.photo,
        createdAt: user.createdAt,
      );

      await _firestore.collection("users").doc(userId).set(data.toMap());

      // 5. Tambahkan ID karyawan ke array di dokumen store
      await _firestore.collection("stores").doc(store.id).update({
        "employees": FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      debugPrint("Error saat membuat karyawan: $e");
      throw Exception("Gagal membuat karyawan: ${e.toString()}");
    }
  }

  Future<Either<Failure, List<UserModel>>> getEmployees() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return Left(Failure("User tidak ditemukan"));
      }

      final userEither = await _userRepo.getUser(userId);
      final user = userEither.getOrElse(
        () => throw Exception("Unexpected null user"),
      );

      if (user.role == 'owner') {
        final stores = await _firestore
            .collection('stores')
            .where("ownerId", isEqualTo: user.id)
            .where("isActive", isEqualTo: true)
            .get()
            .then((value) =>
                value.docs.map((e) => StoreModel.fromMap(e.data())).toList());

        final employeeIds = stores.first.employees;

        if (employeeIds == null || employeeIds.isEmpty) {
          return Left(Failure("Belum ada karyawan"));
        }

        List<UserModel> employeeDatas = [];

        for (var employeeId in employeeIds) {
          final snapshot = await _firestore
              .collection("users")
              .where("id", isEqualTo: employeeId)
              .get();
          final users =
              snapshot.docs.map((e) => UserModel.fromMap(e.data())).toList();
          employeeDatas.addAll(users);
        }

        return Right(employeeDatas);
      }
    } catch (e, stackTrace) {
      log('Error caught', error: e, stackTrace: stackTrace);
    }

    return Left(Failure("Terjadi kesalahan saat mengambil data karyawan"));
  }

  Future<void> deleteEmployee(String id) async {
    final storeRepository = StoreRepository();

    try {
      // Hapus user dari Firestore
      await _firestore.collection('users').doc(id).delete();

      // Ambil user yang sedang login
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Ambil store aktif
      final store = await storeRepository.getActiveStore(userId);
      if (store != null) {
        await _firestore.collection("stores").doc(store.id).update({
          "employees": FieldValue.arrayRemove([id]),
        });
      }
    } catch (e) {
      print("Gagal menghapus karyawan: $e");
      rethrow;
    }
  }
}
