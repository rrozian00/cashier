import 'dart:convert';
import 'dart:io';

import '../../../core/utils/get_user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../core/errors/failure.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> _uploadImageToCloudinary(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();

      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/dvc6x08kw/image/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = 'cashier'
        ..files.add(http.MultipartFile.fromBytes('file', bytes,
            filename: 'product.jpg'));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Gagal upload ke Cloudinary: $resBody");
      }

      final data = jsonDecode(resBody);
      return {
        'secure_url': data['secure_url'],
        'public_id': data['public_id'],
      };
    } catch (e) {
      throw Exception("Upload error: ${e.toString()}");
    }
  }

  Future<void> _deleteImageFromCloudinary(String publicId) async {
    final cloudName = 'dvc6x08kw';
    final apiKey = '941964148458378';
    final apiSecret = '78S7XNfKQwXh_fbSXylOS8h9BUE';

    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Buat signature
    final signatureRaw = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
    final signature = sha1.convert(utf8.encode(signatureRaw)).toString();

    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');

    final response = await http.post(
      uri,
      body: {
        'public_id': publicId,
        'api_key': apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal hapus gambar: ${response.body}");
    }
  }

  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      String? storeId;

      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return Left(Failure("User tidak terautentikasi."));
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.data() != null) {
        storeId = userDoc.data()?['storeId'];
      }

      final snapshot =
          await _firestore.collection('stores/$storeId/products').get();
      final List<ProductModel> products =
          snapshot.docs.map((e) => ProductModel.fromMap(e.data())).toList();
      return Right(products);
    } catch (e) {
      return Left(Failure("Unexpected error $e"));
    }
  }

  //add product
  Future<Either<Failure, ProductModel>> addProduct({
    required String name,
    required String productCode,
    required String price,
    required String imagePath,
  }) async {
    Map<String, dynamic>? result;
    String? storeId;

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Left(Failure("User tidak terautentikasi."));
    }

    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.data() != null) {
      storeId = userDoc.data()?['storeId'];
    }

    File? imageFile = File(imagePath);

    if (imageFile.existsSync()) {
      // Cek ukuran file gambar sebelum kompresi
      final fileSize = await imageFile.length();

      // Menolak gambar yang lebih besar dari 2MB (2 * 1024 * 1024 bytes)
      if (fileSize > 1 * 1024 * 1024) {
        // Get.snackbar("Error",
        //     "Gambar terlalu besar. Harap pilih gambar yang lebih kecil.");
        return Left(
            Failure("Gambar Terlalu besar")); // Tolak file yang terlalu besar
      }

      result = await _uploadImageToCloudinary(imageFile);
    } else {
      // Get.snackbar("Error", "Silakan pilih gambar terlebih dahulu");
      return Left(Failure("Silahkan pilih gambar terlebih dahulu"));
    }

    final isExist = await _firestore
        .collection('stores/$storeId/products')
        .where("barcode", isEqualTo: productCode)
        .get();

    if (isExist.docs.isNotEmpty) {
      // Get.snackbar("Gagal", "Produk sudah ada");
      return Left(Failure("Produk sudah ada"));
    }

    final docRef = _firestore.collection('stores/$storeId/products').doc();

    final createdAt = Timestamp.now();

    final data = ProductModel(
      id: docRef.id,
      barcode: productCode,
      name: name,
      price: price.replaceAll(RegExp(r'[^\d]'), ''),
      image: result['secure_url'],
      publicId: result['public_id'],
      createdAt: createdAt,
    );

    await docRef.set(data.toMap());

    return Right(data);
  }

  //hapus
  Future<void> deleteProduct(String id) async {
    String? storeId;

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return;
    }

    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.data() != null) {
      storeId = userDoc.data()?['storeId'];
    }

    final doc =
        await _firestore.collection('stores/$storeId/products').doc(id).get();
    if (!doc.exists) {
      throw Exception("Produk tidak ditemukan.");
    }

    final data = ProductModel.fromMap(doc.data()!);

    if (data.publicId != null && data.publicId!.isNotEmpty) {
      await _deleteImageFromCloudinary(data.publicId!);
    }

    await _firestore.collection('stores/$storeId/products').doc(id).delete();
  }

  Future<void> editProduct(
    String id,
    String newName,
    String newPrice,
    String newImage,
  ) async {
    String? storeId;

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return;
    }

    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.data() != null) {
      storeId = userDoc.data()?['storeId'];
    }

    // 🔹 Ambil data lama dari Firestore
    final docSnapshot =
        await _firestore.collection('stores/$storeId/products').doc(id).get();

    if (!docSnapshot.exists) {
      throw Exception("Menu tidak ditemukan!");
    }

    final oldData = ProductModel.fromMap(docSnapshot.data()!);

    // 🔹 Gunakan copyWith untuk update hanya field yang diubah
    final updatedData = oldData.copyWith(
      name: newName,
      price: newPrice.replaceAll(RegExp(r'[^\d]'), ''),
      image: newImage,
    );

    // 🔹 Update ke Firestore
    await _firestore
        .collection('stores/$storeId/products')
        .doc(id)
        .update(updatedData.toMap());
  }

  Stream<Either<Failure, List<ProductModel>>> watchProducts() async* {
    try {
      final user = await getUserData();
      if (user == null) {
        yield Left(Failure("User Not found"));
        return;
      }

      if (user.id == null) {
        yield Left(Failure("Store not found for current user"));
        return;
      }
      yield* _firestore
          .collection('stores/${user.storeId}/products')
          .snapshots()
          .map(
        (snap) {
          final data = snap.docs
              .map(
                (e) => ProductModel.fromMap(e.data()),
              )
              .toList();
          return Right(data);
        },
      );
    } catch (e) {
      yield left(Failure('Unexpected error: $e'));
    }
  }

  Future<Either<Failure, ProductModel>> getProductByBarcode(
      String barcode) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return Left(Failure("User tidak terautentikasi."));
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final storeId = userDoc.data()?['storeId'];

      if (storeId == null) {
        return Left(Failure("Store ID tidak ditemukan."));
      }

      final snapshot = await _firestore
          .collection('stores/$storeId/products')
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return Left(Failure("Produk dengan barcode tersebut tidak ditemukan."));
      }

      final product = ProductModel.fromMap(snapshot.docs.first.data());
      return Right(product);
    } catch (e) {
      return Left(Failure("Unexpected error: $e"));
    }
  }
}
