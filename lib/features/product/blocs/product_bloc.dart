import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/product_model.dart';
import '../repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(
    this._productRepository,
  ) : super(ProductInitial()) {
    // 1. GET PRODUCTS (Mengubah State Global)
    on<ProductGetRequested>((event, emit) async {
      emit(ProductLoading());
      final result = await _productRepository.getProducts();
      result.fold(
        (failure) => emit(ProductFailed(message: failure.message)),
        (products) => emit(ProductSuccess(products: products)),
      );
    });

    // 2. ADD PRODUCT (Mutasi Data -> Lalu Refresh List)
    on<ProductAddRequested>((event, emit) async {
      // Kita tidak meng-emit 'ProductLoading' global agar UI list produk tidak hilang/kedip.
      // Jika UI butuh loading di tombol, handle via state local di widget/dialog.
      try {
        final result = await _productRepository.addProduct(
          registeredDate: event.registeredDate,
          expiredDate: event.expiredDate,
          category: event.category,
          name: event.name,
          productCode: event.productCode,
          price: event.price,
          imageFile: event.imageFile,
        );

        result.fold(
          (error) => emit(ProductFailed(message: error.message)),
          (product) {
            // BEST PRACTICE: Setelah sukses menambah, langsung picu ambil data terbaru
            add(ProductGetRequested());
          },
        );
      } catch (e) {
        emit(ProductFailed(message: e.toString()));
      }
    });

    // 3. EDIT PRODUCT (Mutasi Data -> Lalu Refresh List)
    on<ProductEditRequested>((event, emit) async {
      try {
        await _productRepository.editProduct(
          id: event.id,
          newName: event.newName,
          newPrice: event.newPrice,
          newImage: event.newImage,
          oldPublicId: event.publicId,
        );
        // Otomatis memperbarui list di UI setelah edit sukses
        add(ProductGetRequested());
      } catch (e) {
        emit(ProductFailed(message: "Gagal mengubah produk: $e"));
      }
    });

    // 4. DELETE PRODUCT (Mutasi Data -> Lalu Refresh List)
    on<ProductDeleteRequested>((event, emit) async {
      try {
        await _productRepository.deleteProduct(event.id);
        // Otomatis memperbarui list di UI setelah menghapus sukses
        add(ProductGetRequested());
      } catch (e) {
        emit(ProductFailed(message: "Gagal menghapus produk: $e"));
      }
    });
  }
}
