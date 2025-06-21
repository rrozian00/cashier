import 'package:bloc/bloc.dart';
import 'package:cashier/features/store/repositories/store_repository.dart';
import '../../../../core/utils/get_user_data.dart';
import '../../order/models/cart_model.dart';
import '../../order/models/order_model.dart';
import '../../order/repositories/order_repository.dart';
import '../../../store/models/store_model.dart';
import '../../../user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'check_out_event.dart';
part 'check_out_state.dart';

class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  final storeRepo = StoreRepository();
  final orderRepository = OrderRepository();

  CheckOutBloc() : super(CheckOutState.initial()) {
    on<InitCheckOut>(_onInit);
    on<NumberPressed>(_onNumberPressed);
    on<ClearPressed>(_onClearPressed);
    on<ProcessPayment>(_onProcessPayment);
    on<ClearReceipt>(_onClear);
  }

  void _onInit(InitCheckOut event, Emitter<CheckOutState> emit) {
    emit(state.copyWith(
      totalPrice: event.totalHarga,
      paymentAmount: 0,
      displayText: '',
      canProcess: false,
    ));
  }

  void _onNumberPressed(NumberPressed event, Emitter<CheckOutState> emit) {
    String current = state.displayText;

    // Batasi maksimal 12 digit
    if (current.length >= 12) return;

    String newDisplay = current + event.number;

    int paymentAmount = int.tryParse(newDisplay) ?? 0;
    bool canProcess = paymentAmount >= state.totalPrice && paymentAmount != 0;

    emit(state.copyWith(
      paymentAmount: paymentAmount,
      displayText: newDisplay,
      canProcess: canProcess,
    ));
  }

  void _onClearPressed(ClearPressed event, Emitter<CheckOutState> emit) {
    emit(state.copyWith(
      paymentAmount: 0,
      displayText: '',
      canProcess: false,
    ));
  }

  void _onProcessPayment(
      ProcessPayment event, Emitter<CheckOutState> emit) async {
    if (!state.canProcess) {
      emit(state.copyWith(errorMessage: "Pembayaran tidak memenuhi syarat"));
      return;
    }
    emit(state.copyWith(isProcessing: true, errorMessage: null));

    try {
      final user = await getUserData();

      if (user == null) {
        emit(state.copyWith(
            isProcessing: false, errorMessage: "user belum ditemukan"));
        return;
      }

      if (user.role == 'owner') {
        final storeData = await storeRepo.getActiveStore(user.id!);

        final storeId = storeData?.id;
        if (storeId == null) {
          emit(state.copyWith(
              isProcessing: false, errorMessage: "StoreId belum ditemukan"));
          return;
        }
        final createdAt = Timestamp.now();

        final orderModel = OrderModel(
          payment: state.paymentAmount.toString(),
          products: event.cart,
          refund: (state.paymentAmount - state.totalPrice).toString(),
          total: state.totalPrice.toString(),
          createdAt: createdAt,
        );

        // Simpan ke Firestore
        await orderRepository.saveOrder(orderModel);

        emit(state.copyWith(
          isProcessing: false,
          store: storeData,
          user: user,
          processed: true,
        ));
      } else {
        final result = await storeRepo.getStoreAsEmployee(user.id!);
        if (result.isLeft()) {
          emit(state.copyWith(
            isProcessing: false,
            errorMessage: "Gagal ambil store",
          ));
          return;
        }
        final storeData = result.getOrElse(
          () => throw Exception("Tidak ada store"),
        );

        final storeId = storeData.id;
        if (storeId == null) {
          emit(state.copyWith(
              isProcessing: false, errorMessage: "StoreId belum ditemukan"));
          return;
        }
        final createdAt = Timestamp.now();

        final orderModel = OrderModel(
          payment: state.paymentAmount.toString(),
          products: event.cart,
          refund: (state.paymentAmount - state.totalPrice).toString(),
          total: state.totalPrice.toString(),
          createdAt: createdAt,
        );

        // Simpan ke Firestore
        await orderRepository.saveOrder(orderModel);

        emit(state.copyWith(
          isProcessing: false,
          store: storeData,
          user: user,
          processed: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isProcessing: false, errorMessage: e.toString()));
    }
  }

  void _onClear(ClearReceipt event, Emitter<CheckOutState> emit) {
    // emit(state.copyWith(processed: false));
    emit(state.copyWith(
      paymentAmount: 0,
      displayText: '',
      canProcess: false,
      processed: false,
    ));
  }
}
