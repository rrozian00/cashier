import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_errors/failure.dart';

class AuthRepository {
  final _supabaseAuth = Supabase.instance.client.auth;

  Future<bool> checkVerification() async {
    final user = _supabaseAuth.currentUser;
    if (user != null) {
      return user.emailConfirmedAt != null;
    }
    return false;
  }

  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final res = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      if (res.user != null) {
        return Right(res.user!);
      }
    } on AuthApiException catch (e) {
      // debugPrint("Error login: ${e.code}");
      return Left(Failure(e.code!));
    }
    return Left(Failure("Unexpected error"));
  }

  Future<void> logout() async {
    // await _auth.signOut();
    await _supabaseAuth.signOut();
  }

  Future<void> changePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _supabaseAuth.updateUser(UserAttributes(
        password: newPassword,
      ));
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Either<Failure, void>> sendVerification() async {
    final user = _supabaseAuth.currentUser;
    if (user != null && user.email != null) {
      await _supabaseAuth.resend(
        type: OtpType.email,
        email: user.email,
      );
    }
    return Left(Failure("User not found"));
  }
}
