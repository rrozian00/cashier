import 'package:cashier/core/app_errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterRepository {
  Future<Map<Permission, PermissionStatus>> checkPermission() async {
    try {
      final statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
      return statuses;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  /// Pindai perangkat Bluetooth
  Future<Either<Failure, List<BluetoothInfo>>> scanDevices() async {
    try {
      await checkPermission();
      List<BluetoothInfo> results =
          await PrintBluetoothThermal.pairedBluetooths;
      debugPrint("Ditemukan ${results.length} perangkat.");
      return Right(results);
    } catch (e) {
      debugPrint("Gagal scan perangkat: $e");
    } finally {
      await Future.delayed(Duration(seconds: 3)); // Tunggu sampai scan selesai
    }
    return Left(Failure("Tidak ada printer ditemukan"));
  }

  /// Sambungkan ke printer
  Future<Either<Failure, bool>> connectToPrinter(
      String macPrinterAddress) async {
    try {
      bool success = await PrintBluetoothThermal.connect(
          macPrinterAddress: macPrinterAddress);

      return Right(success);
    } catch (e) {
      return Left(Failure("Error: $e"));
    }
  }

  /// Putuskan koneksi printer
  Future<Either<Failure, bool>> disconnectPrinter() async {
    try {
      final result = await PrintBluetoothThermal.disconnect;
      return Right(result);
    } catch (e) {
      debugPrint("Error saat memutus koneksi: $e");
      return Left(Failure("Error: $e"));
    }
  }
}
