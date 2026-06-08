import 'package:bloc/bloc.dart';
import '../../repositories/product_repository.dart';

class CategoryCubit extends Cubit<String> {
  final ProductRepository repo;
  CategoryCubit(this.repo) : super("");

  void selectCategory(String category) async {
    emit(category);
  }
}
