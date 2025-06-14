import 'package:bloc/bloc.dart';
import 'package:cashier/core/utils/get_user_data.dart';
import 'package:equatable/equatable.dart';

import '../../store/models/store_model.dart';
import '../../store/repositories/store_repository.dart';
import '../../user/models/user_model.dart';
import '../../user/repositories/auth_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final authRepository = AuthRepository();
  final storeRepository = StoreRepository();

  HomeBloc() : super(HomeInitial()) {
    on<HomeGetStoreReq>((event, emit) async {
      emit(HomeLoading());

      final user = await getUserData();
      if (user == null) return;
      final storeDoc = await storeRepository.getStore(user.id!);
      storeDoc.fold(
        (failure) {
          emit(HomeError(message: failure.message));
        },
        (stores) {
          for (var storeResult in stores) {
            if (storeResult.isActive == true) {
              final store = storeResult;
              emit(HomeSuccess(user: user, store: store));
              break;
            }
          }
        },
      );
    });
  }
}
