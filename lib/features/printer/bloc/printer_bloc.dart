import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cashier/features/printer/repositories/printer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

part 'printer_event.dart';
part 'printer_state.dart';

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  final printerRepo = PrinterRepository();
  PrinterBloc() : super(PrinterInitial()) {
    on<ScanPrinter>(_onScanPrinter);
    on<SelectPrinter>(_onSelectPrinter);
    on<ConnectPrinter>(_onConnectPrinter);
  }

  Future<void> _onScanPrinter(
      ScanPrinter event, Emitter<PrinterState> emit) async {
    emit(PrinterLoading());
    final permissions = await printerRepo.checkPermission();
    if (permissions.values.any((status) {
      print(status.name);
      return status.isGranted;
    })) {
      print("izin diberikan");
    } else {
      print("tak diberi izin");
    }
    final devices = await printerRepo.scanDevices();
    devices.fold(
      (err) {
        emit(PrinterFailed(message: err.message));
      },
      (devices) {
        if (devices != []) {
          emit(PrinterSuccess(
              isLoading: false,
              devices: devices,
              selectedDeviceId: '',
              connectedDeviceId: ''));
        } else {
          emit(PrinterFailed(message: "Kosong"));
        }
      },
    );
  }

  Future<void> _onConnectPrinter(
      ConnectPrinter event, Emitter<PrinterState> emit) async {
    final cs = state as PrinterSuccess;
    emit(cs.copyWith(isLoading: true));
    final status = await printerRepo.connectToPrinter(event.macAddress);
    status.fold(
      (err) => emit(PrinterFailed(message: err.message)),
      (status) {
        if (status == true) {
          if (state is! PrinterSuccess) return;
          final cs = state as PrinterSuccess;
          emit(cs.copyWith(
              connectedDeviceId: event.macAddress, isLoading: false));
        } else {
          emit(PrinterFailed(message: "Tidak dapat terhubung"));
          add(ScanPrinter());
        }
      },
    );
  }

  Future<void> _onSelectPrinter(
      SelectPrinter event, Emitter<PrinterState> emit) async {
    if (state is! PrinterSuccess) return;

    final cs = state as PrinterSuccess;
    emit(cs.copyWith(selectedDeviceId: event.macAddress));
  }
}
