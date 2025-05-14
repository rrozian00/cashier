import 'package:bloc/bloc.dart';
import '../../store/models/store_model.dart';
import '../../store/repositories/store_repository.dart';
import '../../user/models/user_model.dart';
import '../../user/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository authRepository = AuthRepository();
  final StoreRepository storeRepository = StoreRepository();

  HomeBloc() : super(HomeInitial()) {
    on<HomeGetStoreReq>((event, emit) async {
      emit(HomeLoading());
      final user = await authRepository.getCurrentUser() as UserModel;
      final String storeId = user.storeId!;
      final storeDoc = await storeRepository.getStore(storeId);
      storeDoc.fold(
        (failure) {
          emit(HomeError(message: failure.message));
        },
        (store) {
          emit(HomeSuccess(user: user, store: store));
        },
      );
    });
  }
}
