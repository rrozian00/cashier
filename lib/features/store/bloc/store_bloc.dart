import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cashier/core/utils/get_user_data.dart';
import 'package:cashier/features/store/models/store_model.dart';
import 'package:cashier/features/store/repositories/store_repository.dart';
import 'package:equatable/equatable.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final storeRepo = StoreRepository();

  StoreBloc() : super(StoreInitial()) {
    on<GetStoresList>(_onGetStoreList);
    on<AddStore>(_onAddStore);
  }

  Future<void> _onGetStoreList(
      GetStoresList event, Emitter<StoreState> emit) async {
    emit(StoreLoading());
    final userData = await getUserData();
    final ownerId = userData?.id;
    if (ownerId != null) {
      final storesData = await storeRepo.getStore(ownerId);
      storesData.fold(
        (err) => emit(StoreError(message: err.message)),
        (stores) => emit(GetStoreSuccess(stores: stores)),
      );
    }
  }

  Future<void> _onAddStore(AddStore event, Emitter<StoreState> emit) async {
    emit(StoreLoading());
    await storeRepo.addStore(
      name: event.name,
      address: event.address,
      phone: event.phone,
      logoUrl: event.logoUrl,
    );
    emit(AddStoreSuccess());
  }
}
