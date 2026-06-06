import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/app_errors/failure.dart';
import '../../../core/utils/get_user_data.dart';
import '../../store/models/store_model.dart';
import '../../store/repositories/store_repository.dart';
import '../../user/repositories/user_repository.dart';
import '../models/product_model.dart';
import 'cloudinary.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _supabaseAuth = Supabase.instance.client.auth;
  final _supabase = Supabase.instance.client;
  final userRepo = UserRepository();

  Future<Either<Failure, List<ProductModel>>> getProducts(
      // String category
      ) async {
    try {
      final user = await userRepo
          .getUserDataFromSupabase()
          .then((e) => e.fold((l) => null, (r) => r));
      final userId = user?.id;
      if (userId == null) {
        return Left(Failure("User tidak terautentikasi."));
      }
      final String storeId;

      if (user?.role == 'owner') {
        // final stores = await _firestore
        //     .collection('stores')
        //     .where("ownerId", isEqualTo: userId)
        //     .where("isActive", isEqualTo: true)
        //     .get()
        //     .then(
        //       (value) => value.docs
        //           .map(
        //             (e) => StoreModel.fromMap(e.data()),
        //           )
        //           .toList(),
        //     );
        final stores = await _supabase
            .from('stores')
            .select()
            .eq('owner_id', userId)
            .single()
            .then((value) => StoreModel.fromMap(value));
        storeId = stores.id!;
      } else {
        // final stores = await _firestore
        //     .collection('stores')
        //     .where("employees", arrayContains: user?.id)
        //     .get()
        //     .then(
        //       (value) => value.docs
        //           .map(
        //             (e) => StoreModel.fromMap(e.data()),
        //           )
        //           .toList(),
        //     );
        final stores = await _supabase
            .from('stores')
            .select()
            .eq('employees', userId)
            .single()
            .then((value) => StoreModel.fromMap(value));
        storeId = stores.id!;
      }

      // final snapshot = await _firestore
      //     .collection('stores/$storeId/products')
      //     // .where("category", isEqualTo: category)
      //     .get();

      final List<ProductModel> products = await _supabase
          .from('products')
          .select()
          .eq('store_id', storeId)
          .then((value) => value.map((e) => ProductModel.fromMap(e)).toList());

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
    required int price,
    required File? imageFile,
  }) async {
    Map<String, dynamic>? result;
    try {
      final userId = _supabaseAuth.currentUser?.id;
      if (userId == null) {
        return Left(Failure("User tidak terautentikasi."));
      }

      // final stores = await _firestore
      //     .collection('stores')
      //     .where("ownerId", isEqualTo: userId)
      //     .where("isActive", isEqualTo: true)
      //     .get()
      //     .then(
      //       (value) => value.docs
      //           .map(
      //             (e) => StoreModel.fromMap(e.data()),
      //           )
      //           .toList(),
      //     );
      // final storeId = stores.first.id;
      final stores =
          await _supabase.from('stores').select().eq('owner_id', userId);
      final storeId = stores.first['id'];

      if (storeId == null) {
        return Left(Failure("Store ID tidak ditemukan."));
      }

      if (imageFile != null) {
        result = await Cloudinary.uploadImageToCloudinary(imageFile);
      } else {
        result = {};
      }
      // final isExist = await _firestore
      //     .collection('stores/$storeId/products')
      //     .where("barcode", isEqualTo: productCode)
      //     .get();

      final isExist = await _supabase
          .from('products')
          .select()
          .eq('id', productCode)
          .eq('store_id', storeId)
          .then((e) => e.map((e) => ProductModel.fromMap(e)).toList());

      if (isExist.isNotEmpty) {
        return Left(Failure("Produk sudah ada"));
      }

      // final docRef = _firestore.collection('stores/$storeId/products').doc();

      final data = ProductModel(
        id: productCode,
        storeId: storeId,
        category: category,
        registeredDate: registeredDate,
        expiredDate: expiredDate,
        name: name,
        price: price,
        image: result['secure_url'],
        publicId: result['public_id'],
        createdAt: DateTime.now(),
      );

      // await docRef.set(data.toMap());
      await _supabase.from('products').insert(data.toMap());

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

    // final stores = await _firestore
    //     .collection('stores')
    //     .where("ownerId", isEqualTo: userId)
    //     .where("isActive", isEqualTo: true)
    //     .get()
    //     .then(
    //       (value) => value.docs
    //           .map(
    //             (e) => StoreModel.fromMap(e.data()),
    //           )
    //           .toList(),
    //     );

    final stores = await _supabase
        .from('stores')
        .select()
        .eq('owner_id', userId)
        .single()
        .then((e) => StoreModel.fromMap(e));
    final storeId = stores.id;

    if (storeId == null) {
      throw Exception("User Store id tidak ditemukan.");
    }

    // final doc =
    //     await _firestore.collection('stores/$storeId/products').doc(id).get();
    final product =
        await _supabase.from('products').select().eq('id', id).single();
    if (product.isEmpty) {
      throw Exception("Produk tidak ditemukan.");
    }

    final data = ProductModel.fromMap(product);

    if (data.publicId != null && data.publicId!.isNotEmpty) {
      await Cloudinary.deleteImageFromCloudinary(data.publicId!);
    }

    // await _firestore.collection('stores/$storeId/products').doc(id).delete();
    await _supabase.from('products').delete().eq('id', id);
  }

  Future<void> editProduct({
    //TODO:eidt product
    required String id,
    required String newName,
    required int newPrice,
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
          await Cloudinary.deleteImageFromCloudinary(oldPublicId);
        }
        result = await Cloudinary.uploadImageToCloudinary(newImage);
      }
      final oldData = ProductModel.fromMap(docSnapshot.data()!);

      // 🔹 Gunakan copyWith untuk update hanya field yang diubah
      final updatedData = oldData.copyWith(
        name: newName,
        price: newPrice,
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
      final String storeId;
      final String userId;

      final user = await userRepo
          .getUserDataFromSupabase()
          .then((e) => e.fold((l) => null, (r) => r));
      if (user == null) {
        return Left(Failure("User tidak terautentikasi."));
      }
      userId = user.id!;

      if (user.role == 'owner') {
        // final stores = await _firestore
        //     .collection('stores')
        //     .where("ownerId", isEqualTo: userId)
        //     .where("isActive", isEqualTo: true)
        //     .get()
        //     .then(
        //       (value) => value.docs
        //           .map(
        //             (e) => StoreModel.fromMap(e.data()),
        //           )
        //           .toList(),
        //     );
        final stores = await _supabase
            .from('stores')
            .select()
            .eq('owner_id', userId)
            .single()
            .then((value) => StoreModel.fromMap(value));

        storeId = stores.id!;
      } else {
        // final stores = await _firestore
        //     .collection('stores')
        //     .where("employees", arrayContains: user?.id)
        //     .get()
        //     .then(
        //       (value) => value.docs
        //           .map(
        //             (e) => StoreModel.fromMap(e.data()),
        //           )
        //           .toList(),
        //     );
        final stores = await _supabase
            .from('stores')
            .select()
            .eq('employees', userId)
            .single()
            .then((value) => StoreModel.fromMap(value));
        storeId = stores.id!;
      }
      // final snapshot = await _firestore
      //     .collection('stores/$storeId/products')
      //     .where('barcode', isEqualTo: barcode)
      //     .limit(1)
      //     .get();
      final data = await _supabase
          .from('products')
          .select()
          .eq('store_id', storeId)
          .eq('id', barcode)
          .single();
      if (data.isEmpty) {
        return Left(Failure("Produk dengan barcode tersebut tidak ditemukan."));
      }

      final product = ProductModel.fromMap(data);
      return Right(product);
    } catch (e) {
      return Left(Failure("Unexpected error: $e"));
    }
  }

// Future<void> getProductByCategory(){

// }
}
