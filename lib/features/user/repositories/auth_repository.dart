import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    final doc = await _firestore.collection("users").doc(currentUser.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!).copyWith(id: currentUser.uid);
  }

  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<bool> checkVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      debugPrint("Virified: ${user.emailVerified.toString()}");
      return user.emailVerified;
    }
    return false;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // Re-authenticate sebelum ubah password (wajib oleh Firebase)
        final cred = EmailAuthProvider.credential(
          email: email,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('Silakan login ulang untuk mengubah password.');
      } else {
        throw Exception('Gagal mengubah password: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> sendVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      user.sendEmailVerification();
    }
  }
}
