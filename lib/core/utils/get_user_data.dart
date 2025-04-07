import 'package:cashier/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<UserModel?> getUserData() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final userId = auth.currentUser?.uid;
  if (userId == null) return null; // Jika tidak login, return null

  final docSnapshot = await firestore.collection('users').doc(userId).get();

  if (docSnapshot.exists) {
    return UserModel.fromMap(docSnapshot.data()!);
  }

  return null; // Jika user tidak ditemukan
}
