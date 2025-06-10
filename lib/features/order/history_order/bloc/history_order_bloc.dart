import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../order/models/order_model.dart';
import '../../order/repositories/order_repository.dart';

part 'history_order_event.dart';
part 'history_order_state.dart';

// class HistoryOrderBloc extends Bloc<HistoryOrderEvent, HistoryOrderState> {
//   final orderRepo = OrderRepository();
//   HistoryOrderBloc() : super(HistoryOrderLoaded(orders: )) {
//     on<ShowMyDateRange>(_onShowMydateRange);
//   }

//   Future<void> _onShowMydateRange(
//       ShowMyDateRange event, Emitter<HistoryOrderState> emit) async {
//     emit(HistoryOrderLoading());
//     final DateTimeRange? picked = await showDateRangePicker(
//         context: event.context,
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2101),
//         initialDateRange: null);

//     if (picked != null) {
//       final start = picked.start;
//       final end = picked.end.add(Duration(days: 1));
//       final result = await orderRepo.getHistoryOrders(
//           Timestamp.fromDate(start), Timestamp.fromDate(end));
//       result.fold(
//         (err) => emit(
//           HistoryOrderFailed(message: err.message),
//         ),
//         (datas) {
//           emit(HistoryOrderLoaded(
//             orders: datas,
//             picked: picked,
//           ));
//         },
//       );
//     }
//   }
// }
class HistoryOrderBloc extends Bloc<HistoryOrderEvent, HistoryOrderState> {
  final orderRepo = OrderRepository();
  final BuildContext
      context; // Tambahkan context jika diperlukan untuk date picker

  HistoryOrderBloc({required this.context}) : super(HistoryOrderLoading()) {
    on<ShowMyDateRange>(_onShowMydateRange);
    on<ShowInitial>(_onShowInitial); // Panggil fungsi inisialisasi
  }

  // Fungsi untuk load data default (1 minggu terakhir)
  Future<void> _onShowInitial(
      ShowInitial event, Emitter<HistoryOrderState> emit) async {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 7)); // 1 minggu terakhir

    final result = await orderRepo.getHistoryOrders(
      Timestamp.fromDate(start),
      Timestamp.fromDate(end),
    );

    result.fold(
        (err) => emit(HistoryOrderFailed(message: err.message)),
        (datas) => emit(
              HistoryOrderLoaded(
                orders: datas,
                picked:
                    DateTimeRange(start: start, end: end), // Set range default
              ),
            ));
  }

  Future<void> _onShowMydateRange(
      ShowMyDateRange event, Emitter<HistoryOrderState> emit) async {
    emit(HistoryOrderLoading());
    final DateTimeRange? picked = await showDateRangePicker(
      context: event.context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange:
          (state as HistoryOrderLoaded).picked, // Gunakan range terakhir
    );

    if (picked != null) {
      final start = picked.start;
      final end = picked.end.add(const Duration(days: 1));
      final result = await orderRepo.getHistoryOrders(
        Timestamp.fromDate(start),
        Timestamp.fromDate(end),
      );

      result.fold(
        (err) => emit(HistoryOrderFailed(message: err.message)),
        (datas) => emit(HistoryOrderLoaded(
          orders: datas,
          picked: picked,
        )),
      );
    }
  }
}
