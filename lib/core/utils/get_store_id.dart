import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Future<String> getStoreId() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final storeId = ''.obs;
  final userId = auth.currentUser?.uid;
  if (userId == null) return "";

  final ownerStore = await firestore
      .collection('stores')
      .where('ownerId', isEqualTo: userId)
      .get();

  if (ownerStore.docs.isNotEmpty) {
    storeId.value = ownerStore.docs.first.id;
    return storeId.value;
  } else {
    // Jika bukan owner, cek apakah user adalah karyawan
    QuerySnapshot<Map<String, dynamic>> employeeStore = await firestore
        .collection('stores')
        .where('employees', arrayContains: userId)
        .get();

    if (employeeStore.docs.isNotEmpty) {
      storeId.value = employeeStore.docs.first.id;
      return storeId.value;
    }
  }
  return '';
}
