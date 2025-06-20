import 'package:bloc/bloc.dart';
import '../../../core/utils/get_user_data.dart';
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
      if (user.role == "owner") {
        final storeDoc = await storeRepository.getStoreAsOwner(user.id!);
        storeDoc.fold(
          (failure) {
            emit(HomeError(message: failure.message));
          },
          (stores) {
            for (var storeResult in stores) {
              if (stores.any((e) => e.isActive == false)) {
                emit(HomeError(message: "Aktifkan Toko Anda terlebih dahulu."));
              }
              if (storeResult.isActive == true) {
                emit(HomeSuccess(user: user, store: storeResult));
                break;
              }
            }
          },
        );
      } else {
        final storeDoc = await storeRepository.getStoreAsEmployee(user.id!);
        storeDoc.fold(
          (failure) {
            emit(HomeError(message: failure.message));
          },
          (store) {
            emit(HomeSuccess(user: user, store: store));
          },
        );
      }
    });
  }
}
