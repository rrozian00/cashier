import 'package:bloc/bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(2);

  void updateIndex(int index) => emit(index);
}
