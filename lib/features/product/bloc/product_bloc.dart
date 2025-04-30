import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cashier/features/product/models/product_model.dart';
import 'package:cashier/features/product/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository = ProductRepository();
  final ImagePicker _picker = ImagePicker();

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
            name: event.name,
            productCode: event.productCode,
            price: event.price,
            imagePath: event.image);

        result.fold((error) => emit(ProductFailed(message: error.message)),
            (product) => emit(ProductAddSuccess()));
      },
    );

    on<ProductPickImageReq>(
      (event, emit) async {
        emit(ProductPickLoading());
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final image = pickedFile.path;
          emit(PickImageSuccess(image));
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
          event.id,
          event.newName,
          event.newPrice,
          event.newImage,
        );
        emit(ProductEditSuccess());
      },
    );
  }
}
