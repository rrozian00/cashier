import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_errors/failure.dart';
import '../../store/models/store_model.dart';
import '../../store/repositories/store_repository.dart';
import '../../user/models/user_model.dart';
import '../../user/repositories/user_repository.dart';

class EmployeeRepo {
  final UserRepository _userRepo = UserRepository();
  final storeRepo = StoreRepository();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Either<Failure, void>> createEmployee({
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
        return Left(Failure("Gagal membuat karyawan"));
      }

      final newUserId = newUser.id;

      // 2. Login ulang sebagai owner agar tidak kehilangan sesi
      if (ownerSession != null) {
        await _supabase.auth.setSession(
          ownerSession.refreshToken!,
        );
      }

      // 3. Ambil data store owner dari Firestore
      // final stores = await _firestore
      //     .collection("stores")
      //     .where("ownerId", isEqualTo: ownerUser.id)
      //     .where("isActive", isEqualTo: true)
      //     .get()
      //     .then((snap) =>
      //         snap.docs.map((e) => StoreModel.fromMap(e.data())).toList());
      final List<StoreModel> stores = await storeRepo
          .getStore(ownerUser.id)
          .then((value) => value.fold((l) => [], (r) => r));
      if (stores.isEmpty) return Left(Failure("Store tidak ditemukan."));
      final store = stores.first;

      // 4. Pastikan tidak duplikat di Firestore
      // final userQuery = await _firestore
      //     .collection('users')
      //     .where('email', isEqualTo: email)
      //     .get();
      final userQuery =
          await _supabase.from('users').select().eq('email', email);
      if (userQuery.isNotEmpty) {
        return Left(Failure("Email sudah digunakan di Firestore."));
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
        createdAt: DateTime.now(),
      );

      // await _firestore.collection("users").doc(newUserId).set(employee.toMap());
      await _supabase.from('users').insert(employee.toMap());

      // 6. Tambahkan ke array "employees" di dokumen store
      // await _firestore.collection("stores").doc(store.id).update({
      //   "employees": FieldValue.arrayUnion([newUserId]),
      // });
      final data =
          store.copyWith(employees: [...store.employees ?? [], newUserId]);
      await _supabase.from('stores').update(data.toMap()).eq('id', store.id!);
      return Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<UserModel>>> getEmployees() async {
    try {
      final userEither = await _userRepo.getUserDataFromSupabase();
      final user = userEither.getOrElse(
        () => throw Exception("User tidak ditemukan"),
      );

      if (user.role == 'owner') {
        // final stores = await _firestore
        //     .collection('stores')
        //     .where("ownerId", isEqualTo: user.id)
        //     .where("isActive", isEqualTo: true)
        //     .get()
        //     .then((value) =>
        //         value.docs.map((e) => StoreModel.fromMap(e.data())).toList());
        final StoreModel store = await storeRepo.getActiveStore(user.id!).then(
            (value) => value.fold((l) => throw Exception(l.message), (r) => r));
        final employeeIds = store.employees;

        if (employeeIds == null || employeeIds.isEmpty) {
          return Left(Failure("null"));
        }

        List<UserModel> employeeList = [];

        for (var employeeId in employeeIds) {
          // final snapshot = await _firestore
          //     .collection("users")
          //     .where("id", isEqualTo: employeeId)
          //     .get();

          final snapshot =
              await _supabase.from('users').select().eq('id', employeeId);

          final users = snapshot.map((e) => UserModel.fromMap(e)).toList();
          employeeList.addAll(users);
        }

        return Right(employeeList);
      }
    } catch (e) {
      print(e);
    }

    return Left(Failure("Terjadi kesalahan saat mengambil data karyawan"));
  }

  Future<Either<Failure, void>> deleteEmployee(String id) async {
    try {
      final storeRepository = StoreRepository();

      const serviceRoleKey =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56dmZpY3BmcnB2Z2h2YWp0b2tyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4MDU2NzkzMiwiZXhwIjoyMDk2MTQzOTMyfQ.uqGxLFT8-9IjZXUsZ3NwoSznX17YvyqjfSdESbhm_vo";
      const projectUrl = "https://nzvficpfrpvghvajtokr.supabase.co";

      final res = await http
          .delete(Uri.parse("$projectUrl/auth/v1/admin/users/$id"), headers: {
        'apikey': serviceRoleKey,
        'Authorization': 'Bearer $serviceRoleKey',
      });
      print(res.statusCode);
      if (res.statusCode == 200) {
        // Hapus user dari Firestore
        // await _firestore.collection('users').doc(id).delete();
        await _supabase.from('users').delete().eq('id', id);

        // Ambil ownerId
        final ownerId = _supabase.auth.currentUser?.id;
        if (ownerId == null) return Left(Failure("User tidak ditemukan."));

        // Ambil store aktif
        final store = await storeRepository
            .getActiveStore(ownerId)
            .then((e) => e.fold((l) => null, (r) => r));
        if (store != null) {
          // await _firestore.collection("stores").doc(store.id).update({
          //   "employees": FieldValue.arrayRemove([id]),
          // });
          final employees = [...store.employees ?? []];
          employees.remove(id);
          await _supabase
              .from('stores')
              .update({"employees": employees}).eq('id', store.id!);
        }
        print('✅ User berhasil dihapus dari Supabase Auth.');
        return Right(null);
      } else {
        print('❌ Gagal menghapus user: ${res.body}');
        return Left(Failure("Gagal menghapus karyawan"));
      }
    } catch (e) {
      print("Gagal menghapus karyawan: $e");
      return Left(Failure("Gagal menghapus karyawan"));
    }
  }
}
