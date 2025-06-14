import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

Future<UserModel?> getUserData() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;
  final userId = user.id;
  final docSnapshot = await firestore.collection('users').doc(userId).get();

  if (docSnapshot.exists) {
    try {
      return UserModel.fromMap(docSnapshot.data()!);
    } catch (e) {
      debugPrint("Error parsing UserModel: $e");
    }
  }
  return null;
}
