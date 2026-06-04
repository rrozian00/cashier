import '../../../core/app_errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<Failure, User?>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential.user);
    } catch (e) {
      return Left(Failure('Login gagal: $e'));
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await _auth.signOut();
      return Right(null);
    } catch (e) {
      return Left(Failure('Gagal logout: $e'));
    }
  }

  Future<Either<Failure, void>> changePassword({
    required String newPassword,
  }) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      return Right(null);
    } catch (e) {
      return Left(Failure('Terjadi kesalahan: $e'));
    }
  }

  Future<Either<Failure, User?>> getCurentUser() async {
    try {
      return Right(_auth.currentUser);
    } catch (e) {
      return Left(Failure('Gagal mendapatkan data user: $e'));
    }
  }
}
