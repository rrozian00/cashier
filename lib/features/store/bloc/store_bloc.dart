import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../user/repositories/user_repository.dart';
import '../models/store_model.dart';
import '../repositories/store_repository.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository storeRepo;
  final UserRepository userRepo;

  StoreBloc(this.storeRepo, this.userRepo) : super(StoreInitial()) {
    on<StoreFetched>(_onGetStoreList);
    on<AddStore>(_onAddStore);
    on<MakeStoreActive>(_onMakeStoreActive);
    on<UpdateStore>(_onUpdateStore);
  }

  Future<void> _onGetStoreList(
      StoreFetched event, Emitter<StoreState> emit) async {
    emit(StoreLoading());
    final user = await userRepo
        .getUserDataFromSupabase()
        .then((e) => e.fold((l) => null, (r) => r));
    final ownerId = user?.id;
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

    final user = await userRepo
        .getUserDataFromSupabase()
        .then((e) => e.fold((l) => null, (r) => r));
    if (user != null) {
      await storeRepo.addStore(
        ownerId: user.id!,
        name: event.name,
        address: event.address,
        phone: event.phone,
        logoUrl: event.logoUrl,
      );
    }
    emit(AddStoreSuccess());
  }

  Future<void> _onMakeStoreActive(
      MakeStoreActive event, Emitter<StoreState> emit) async {
    emit(StoreLoading());
    await storeRepo.activateStore(event.id);
    emit(UpdateStoreSuccess());
  }

  Future<void> _onUpdateStore(
      UpdateStore event, Emitter<StoreState> emit) async {
    emit(StoreLoading());
    await storeRepo.updateStore(
        store: event.store,
        name: event.name,
        address: event.address,
        phone: event.phone);
    emit(UpdateStoreSuccess());
  }
}
