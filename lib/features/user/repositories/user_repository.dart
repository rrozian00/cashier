import 'package:cashier/core/errors/failure.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUser(UserModel user, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email!, password: password);

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
        createdAt: user.createdAt);

    await _firestore.collection("users").doc(data.id).set(data.toMap());
  }

  Future<void> createEmployee(UserModel user, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: user.email!, password: password);

      final data = UserModel(
          id: userCredential.user?.uid,
          storeId: user.storeId,
          email: user.email,
          name: user.name,
          address: user.address,
          salary: user.salary,
          role: "employee",
          phoneNumber: user.phoneNumber,
          photo: user.photo,
          createdAt: user.createdAt);

      final QuerySnapshot<Map<String, dynamic>> userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();
      if (userQuery.docs.isNotEmpty) {
        throw Exception("Email sudah ada");
      }

      if (user.storeId == null) {
        throw Exception("Store tidak ditemukan");
      }
      await _firestore
          .collection("users")
          .doc(userCredential.user?.uid)
          .set(data.toMap());

      // final storeRef = _firestore.collection("stores").doc(user.storeId);
      // final snapshot = await storeRef.get();

      // if (!snapshot.exists) {
      //   // Buat dulu dokumen kosong, bisa dengan default value
      //   await storeRef.set({"employees": []});
      // }
      await _firestore.collection("stores").doc(user.storeId).update({
        "employees": FieldValue.arrayUnion([userCredential.user?.uid])
      });
    } catch (e) {
      debugPrint("Error saat membuat karyawan: $e");
      if (e is FirebaseException) {
        throw Exception("Firebase Error: ${e.message}");
      } else {
        throw Exception("Gagal membuat karyawan: ${e.toString()}");
      }
    }
  }

  Future<void> editUser({
    required String newName,
    required String newAddress,
    required String newPhone,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception("User belum login");

    final docRef = _firestore
        .collection('users')
        .doc(userId)
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

  Future<List<UserModel>> getEmployees() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final user = await getUser(userId);
    if (user == null) return [];

    final storeDoc =
        await _firestore.collection('stores').doc(user.storeId).get();

    final employeesData = storeDoc.data()?['employees'] as List<dynamic>?;

    if (employeesData == null) return [];

    final employeeQuery = await _firestore
        .collection("users")
        .where(FieldPath.documentId, whereIn: employeesData)
        .get();

    // Convert setiap item di array ke UserModel
    final employees =
        employeeQuery.docs.map((d) => UserModel.fromMap(d.data())).toList();

    return employees;
  }
}
