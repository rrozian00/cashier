import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../store/models/store_model.dart';
import '../../../store/repositories/store_repository.dart';
import '../../../user/models/user_model.dart';
import '../../../user/repositories/user_repository.dart';
import '../../order/models/cart_model.dart';
import '../../order/models/order_model.dart';
import '../../order/repositories/order_repository.dart';

part 'check_out_event.dart';
part 'check_out_state.dart';

class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  final storeRepo = StoreRepository();
  final orderRepository = OrderRepository();
  final userRepo = UserRepository();

  CheckOutBloc() : super(CheckOutLoading()) {
    on<InitCheckOut>(_onInit);
    on<NumberPressed>(_onNumberPressed);
    on<ClearPressed>(_onClearPressed);
    on<ProcessPayment>(_onProcessPayment);
    on<ClearReceipt>(_onClear);
  }

  void _onInit(InitCheckOut event, Emitter<CheckOutState> emit) {
    emit(CheckOutInitial(
        cart: event.cart,
        paymentAmount: 0,
        totalPrice: event.totalHarga,
        isProcessing: false,
        processed: false,
        displayText: '',
        canProcess: false));
  }

  void _onNumberPressed(NumberPressed event, Emitter<CheckOutState> emit) {
    final state = this.state as CheckOutInitial;

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
    final state = this.state as CheckOutInitial;

    emit(state.copyWith(
      paymentAmount: 0,
      displayText: '',
      canProcess: false,
    ));
  }

  void _onProcessPayment(
      ProcessPayment event, Emitter<CheckOutState> emit) async {
    final state = this.state as CheckOutInitial;

    if (!state.canProcess) {
      emit(state.copyWith(errorMessage: "Pembayaran tidak memenuhi syarat"));
      return;
    }

    emit(state.copyWith(isProcessing: true, errorMessage: null));

    try {
      final user = await userRepo
          .getUserDataFromSupabase()
          .then((e) => e.fold((l) => null, (r) => r));

      if (user == null) {
        emit(CheckOutError(errorMessage: "Gagal ambil user"));
        return;
      }

      if (user.role == 'owner') {
        final storeData = await storeRepo
            .getActiveStore(user.id!)
            .then((e) => e.fold((l) => null, (r) => r));

        final storeId = storeData?.id;
        if (storeId == null) {
          emit(CheckOutError(errorMessage: "StoreId belum ditemukan"));
          return;
        }

        final orderModel = OrderModel(
          name: "Order",
          storeId: storeId,
          payment: state.paymentAmount,
          products: event.cart,
          change: (state.paymentAmount - state.totalPrice),
          total: state.totalPrice,
          createdAt: DateTime.now(),
        );

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

        final orderModel = OrderModel(
          payment: state.paymentAmount,
          products: event.cart,
          change: (state.paymentAmount - state.totalPrice),
          total: state.totalPrice,
          createdAt: DateTime.now(),
        );

        // Simpan ke DAtabase
        final res = await orderRepository.saveOrder(orderModel);
        res.fold(
          (l) => emit(CheckOutError(errorMessage: l.message)),
          (r) => emit(state.copyWith(
            isProcessing: false,
            errorMessage: null,
          )),
        );
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
    final state = this.state as CheckOutInitial;

    emit(state.copyWith(
      paymentAmount: 0,
      displayText: '',
      canProcess: false,
      processed: false,
    ));
  }
}
