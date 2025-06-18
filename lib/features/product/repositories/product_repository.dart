import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_errors/failure.dart';
import '../../../core/utils/get_user_data.dart';
import '../../store/models/store_model.dart';
import '../../store/repositories/store_repository.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _supabaseAuth = Supabase.instance.client.auth;

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
      final user = await getUserData();
      final userId = user?.id;
      if (userId == null) {
        return Left(Failure("User tidak terautentikasi."));
      }
      final String storeId;

      if (user?.role == 'owner') {
        final stores = await _firestore
            .collection('stores')
            .where("ownerId", isEqualTo: userId)
            .where("isActive", isEqualTo: true)
            .get()
            .then(
              (value) => value.docs
                  .map(
                    (e) => StoreModel.fromMap(e.data()),
                  )
                  .toList(),
            );
        storeId = stores.first.id!;
      } else {
        final stores = await _firestore
            .collection('stores')
            .where("employees", arrayContains: user?.id)
            .get()
            .then(
              (value) => value.docs
                  .map(
                    (e) => StoreModel.fromMap(e.data()),
                  )
                  .toList(),
            );
        storeId = stores.first.id!;
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
    required String category,
    required DateTime registeredDate,
    required DateTime expiredDate,
    required String productCode,
    required String price,
    required File? imageFile,
  }) async {
    Map<String, dynamic>? result;
    try {
      final userId = _supabaseAuth.currentUser?.id;
      if (userId == null) {
        return Left(Failure("User tidak terautentikasi."));
      }

      final stores = await _firestore
          .collection('stores')
          .where("ownerId", isEqualTo: userId)
          .where("isActive", isEqualTo: true)
          .get()
          .then(
            (value) => value.docs
                .map(
                  (e) => StoreModel.fromMap(e.data()),
                )
                .toList(),
          );
      final storeId = stores.first.id;

      if (storeId == null) {
        return Left(Failure("Store ID tidak ditemukan."));
      }

      if (imageFile != null) {
        result = await _uploadImageToCloudinary(imageFile);
      } else {
        result = {};
      }
      final isExist = await _firestore
          .collection('stores/$storeId/products')
          .where("barcode", isEqualTo: productCode)
          .get();

      if (isExist.docs.isNotEmpty) {
        return Left(Failure("Produk sudah ada"));
      }

      final docRef = _firestore.collection('stores/$storeId/products').doc();

      final createdAt = Timestamp.now();
      final registerTimestatmp = Timestamp.fromDate(registeredDate);
      final expiredTimestatmp = Timestamp.fromDate(expiredDate);
      final data = ProductModel(
        id: docRef.id,
        barcode: productCode,
        category: category,
        registerDate: registerTimestatmp,
        expiredDate: expiredTimestatmp,
        name: name,
        price: price.replaceAll(RegExp(r'[^\d]'), ''),
        image: result['secure_url'],
        publicId: result['public_id'],
        createdAt: createdAt,
      );

      await docRef.set(data.toMap());

      return Right(data);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //hapus
  Future<void> deleteProduct(String id) async {
    final userId = _supabaseAuth.currentUser?.id;
    if (userId == null) {
      throw Exception("User tidak terautentikasi.");
    }

    final stores = await _firestore
        .collection('stores')
        .where("ownerId", isEqualTo: userId)
        .where("isActive", isEqualTo: true)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => StoreModel.fromMap(e.data()),
              )
              .toList(),
        );
    final storeId = stores.first.id;

    if (storeId == null) {
      throw Exception("User Store id tidak ditemukan.");
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

  Future<void> editProduct({
    required String id,
    required String newName,
    required String newPrice,
    File? newImage,
    String? oldPublicId,
  }) async {
    try {
      Map<String, dynamic>? result;
      final repo = StoreRepository();
      final userId = _supabaseAuth.currentUser?.id;
      if (userId == null) {
        return;
      }
      final store = await repo.getActiveStore(userId);
      if (store == null) {
        throw Exception("Store ID tidak ditemukan!");
      }
      final storeId = store.id;
      // 🔹 Ambil data lama dari Firestore
      final docSnapshot =
          await _firestore.collection('stores/$storeId/products').doc(id).get();

      if (!docSnapshot.exists) {
        throw Exception("Menu tidak ditemukan!");
      }

      if (newImage != null) {
        if (oldPublicId != null && oldPublicId != "") {
          await _deleteImageFromCloudinary(oldPublicId);
        }
        result = await _uploadImageToCloudinary(newImage);
      }
      final oldData = ProductModel.fromMap(docSnapshot.data()!);

      // 🔹 Gunakan copyWith untuk update hanya field yang diubah
      final updatedData = oldData.copyWith(
        name: newName,
        price: newPrice.replaceAll(RegExp(r'[^\d]'), ''),
        image: result?['secure_url'],
        publicId: result?['public_id'],
      );

      // 🔹 Update ke Firestore
      await _firestore
          .collection('stores/$storeId/products')
          .doc(id)
          .update(updatedData.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
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

  //get product
  Future<Either<Failure, ProductModel>> getProductByBarcode(
      String barcode) async {
    try {
      final user = await getUserData();
      final userId = user?.id;
      if (userId == null) {
        return Left(Failure("User tidak terautentikasi."));
      }

      final String storeId;

      if (user?.role == 'owner') {
        final stores = await _firestore
            .collection('stores')
            .where("ownerId", isEqualTo: userId)
            .where("isActive", isEqualTo: true)
            .get()
            .then(
              (value) => value.docs
                  .map(
                    (e) => StoreModel.fromMap(e.data()),
                  )
                  .toList(),
            );
        storeId = stores.first.id!;
      } else {
        final stores = await _firestore
            .collection('stores')
            .where("employees", arrayContains: user?.id)
            .get()
            .then(
              (value) => value.docs
                  .map(
                    (e) => StoreModel.fromMap(e.data()),
                  )
                  .toList(),
            );
        storeId = stores.first.id!;
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
