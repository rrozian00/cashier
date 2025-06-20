import 'package:bloc/bloc.dart';
import 'package:cashier/features/product/repositories/product_repository.dart';

class CategoryCubit extends Cubit<String> {
  final repo = ProductRepository();
  CategoryCubit() : super("");

  void selectCategory(String category) async {
    emit(category);
  }
}
