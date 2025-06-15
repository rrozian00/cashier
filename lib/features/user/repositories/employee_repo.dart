import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_errors/failure.dart';
import '../../store/models/store_model.dart';
import '../../store/repositories/store_repository.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

class EmployeeRepo {
  final UserRepository _userRepo = UserRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createEmployee({
    required String name,
    required String email,
    required String password,
    required String address,
    required String phone,
    required String salary,
  }) async {
    try {
      // 0. Simpan session owner sebelum signUp
      final ownerSession = _supabase.auth.currentSession;
      final ownerUser = _supabase.auth.currentUser;
      if (ownerUser == null) throw Exception("Owner tidak terautentikasi.");

      // 1. Sign up employee (akan mengubah currentUser ke karyawan)
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final newUser = res.user;
      if (newUser == null) {
        throw Exception("Gagal membuat user baru.");
      }

      final newUserId = newUser.id;

      // 2. Login ulang sebagai owner agar tidak kehilangan sesi
      if (ownerSession != null) {
        await _supabase.auth.setSession(
          ownerSession.refreshToken!,
        );
      }

      // 3. Ambil data store owner dari Firestore
      final stores = await _firestore
          .collection("stores")
          .where("ownerId", isEqualTo: ownerUser.id)
          .where("isActive", isEqualTo: true)
          .get()
          .then((snap) =>
              snap.docs.map((e) => StoreModel.fromMap(e.data())).toList());

      if (stores.isEmpty) throw Exception("Store tidak ditemukan.");
      final store = stores.first;

      // 4. Pastikan tidak duplikat di Firestore
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (userQuery.docs.isNotEmpty) {
        throw Exception("Email sudah digunakan di Firestore.");
      }

      // 5. Simpan data employee di Firestore
      final employee = UserModel(
        id: newUserId,
        storeId: store.id,
        email: email,
        name: name,
        address: address,
        salary: salary,
        role: "employee",
        phoneNumber: phone,
        createdAt: Timestamp.now(),
      );

      await _firestore.collection("users").doc(newUserId).set(employee.toMap());

      // 6. Tambahkan ke array "employees" di dokumen store
      await _firestore.collection("stores").doc(store.id).update({
        "employees": FieldValue.arrayUnion([newUserId]),
      });
    } catch (e, st) {
      debugPrint("❌ Error saat createEmployee: $e");
      debugPrintStack(stackTrace: st);
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
          return Left(Failure("null"));
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
    } catch (e) {
      print(e);
    }

    return Left(Failure("Terjadi kesalahan saat mengambil data karyawan"));
  }

  Future<void> deleteEmployee(String id) async {
    try {
      const serviceRoleKey =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJycWp2bWZtY2h5ZWxleGlpbnZ3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0OTg2NDEzOSwiZXhwIjoyMDY1NDQwMTM5fQ.y_WTSYoqllkNtQOWgt1J7LujHkEGHxb3G_-DwcpzsqI";
      const projectUrl = "https://brqjvmfmchyelexiinvw.supabase.co";
      final storeRepository = StoreRepository();

      final res = await http
          .delete(Uri.parse("$projectUrl/auth/v1/admin/users/$id"), headers: {
        'apikey': serviceRoleKey,
        'Authorization': 'Bearer $serviceRoleKey',
      });
      print(res.statusCode);
      if (res.statusCode == 200) {
        // Hapus user dari Firestore
        await _firestore.collection('users').doc(id).delete();

        // Ambil ownerId
        final ownerId = _supabase.auth.currentUser?.id;
        if (ownerId == null) return;

        // Ambil store aktif
        final store = await storeRepository.getActiveStore(ownerId);
        if (store != null) {
          await _firestore.collection("stores").doc(store.id).update({
            "employees": FieldValue.arrayRemove([id]),
          });
        }
        print('✅ User berhasil dihapus dari Supabase Auth.');
      } else {
        print('❌ Gagal menghapus user: ${res.body}');
        throw Exception('Gagal menghapus user: ${res.body}');
      }
    } catch (e) {
      print("Gagal menghapus karyawan: $e");
      rethrow;
    }
  }
}
