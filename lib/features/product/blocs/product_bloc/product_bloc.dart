import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/product_model.dart';
import '../../repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository = ProductRepository();
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  ProductBloc() : super(ProductInitial()) {
    on<ProductGetRequested>((event, emit) async {
      emit(ProductLoading());
      final result = await _productRepository.getProducts();
      result.fold(
        (failure) {
          emit(ProductFailed(message: failure.message));
        },
        (products) {
          emit(ProductSuccess(products: products));
        },
      );
    });

    on<ProductAddRequested>(
      (event, emit) async {
        emit(ProductAddLoading());
        final result = await _productRepository.addProduct(
          registeredDate: event.registeredDate,
          expiredDate: event.expiredDate,
          category: event.category,
          name: event.name,
          productCode: event.productCode,
          price: event.price,
          imageFile: _pickedImage,
        );

        result.fold((error) {
          _pickedImage = null;
          emit(ProductFailed(message: error.message));
        }, (product) {
          _pickedImage = null;
          emit(ProductAddSuccess());
        });
      },
    );

    on<ProductPickImageReq>(
      (event, emit) async {
        emit(ProductPickLoading());
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final image = pickedFile.path;

          File? imageFile = File(image);
          if (imageFile.existsSync()) {
            // Cek ukuran file gambar
            final fileSize = await imageFile.length();

            // Menolak gambar yang lebih besar dari 2MB (2 * 1024 * 1024 bytes)
            if (fileSize > 1 * 1024 * 1024) {
              _pickedImage = null;
              emit(PickImageError(message: "Ukuran gambar terlalu besar"));
            } else {
              _pickedImage = imageFile;
              emit(PickImageSuccess(image));
            }
          }
        }
      },
    );

    on<ProductDeleteRequested>(
      (event, emit) async {
        emit(ProductDeleteLoading());
        await _productRepository.deleteProduct(event.id);
        emit(ProductDeleteSuccess());
      },
    );

    on<ProductEditRequested>(
      (event, emit) async {
        emit(ProductEditLoading());
        await _productRepository.editProduct(
          id: event.id,
          newName: event.newName,
          newPrice: event.newPrice,
          newImage: _pickedImage,
          oldPublicId: event.publicId,
        );
        _pickedImage = null;
        emit(ProductEditSuccess());
      },
    );

    on<ProductCategoryChanged>((event, emit) {
      emit(ProductCategoryUpdated(category: event.category));
    });
  }
}
