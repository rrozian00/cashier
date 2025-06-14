import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabaseAuth = Supabase.instance.client.auth;

  Future<bool> checkVerification() async {
    final user = _supabaseAuth.currentUser;
    if (user != null) {
      return user.emailConfirmedAt != null;
    }
    return false;
  }

  Future<void> logout() async {
    // await _auth.signOut();
    await Supabase.instance.client.auth.signOut();
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

  Future<void> sendVerification() async {
    // final user = _supabaseAuth.currentUser;
    // if (user != null) {
    //   user.c;
    // }
    //TODO:send email verif
  }
}
