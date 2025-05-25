import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterController extends GetxController {
  var devices = <BluetoothInfo>[].obs;
  var isConnected = false.obs;
  var selectedPrinter = Rx<BluetoothInfo?>(null);

  var isScanning = false.obs;
  var isLoading = false.obs;

  /// Cek izin Bluetooth sebelum scan
  // Future<void> checkPermission() async {
  //   var status = await Permission.bluetooth.request();
  //   if (status.isGranted) {
  //     debugPrint("Izin Bluetooth diberikan.");
  //   } else {
  //     debugPrint("Izin Bluetooth ditolak.");
  //   }
  // }
  Future<void> checkPermission() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses.values.every((status) => status.isGranted)) {
      debugPrint("Semua izin Bluetooth diberikan.");
    } else {
      debugPrint("Ada izin yang ditolak: $statuses");
    }
  }

  /// Pindai perangkat Bluetooth
  Future<void> scanDevices() async {
    isConnected.value = false;
    isScanning.value = true; // 🔹 Set loading saat scan dimulai
    devices.clear();
    try {
      await checkPermission();
      List<BluetoothInfo> results =
          await PrintBluetoothThermal.pairedBluetooths;
      devices.value = results;
      debugPrint("Ditemukan ${devices.length} perangkat.");
    } catch (e) {
      debugPrint("Gagal scan perangkat: $e");
    } finally {
      await Future.delayed(Duration(seconds: 3)); // Tunggu sampai scan selesai
      isScanning.value = false; // 🔹 Set false setelah scan selesai
    }
  }

  /// Sambungkan ke printer
  Future<void> connectToPrinter() async {
    if (selectedPrinter.value == null) {
      debugPrint("Pilih printer terlebih dahulu.");
      Get.snackbar("Error", "Pilih printer terlebih dahulu.");
      return;
    }
    try {
      isLoading.value = true;
      bool success = await PrintBluetoothThermal.connect(
          macPrinterAddress: selectedPrinter.value!.macAdress);
      isConnected.value = success;
      if (success) {
        debugPrint(
            "Berhasil terhubung ke printer: ${selectedPrinter.value!.name}");
        // Get.snackbar("Sukses",
        //     "Berhasil terhubung ke printer: ${selectedPrinter.value!.name}");
      } else {
        debugPrint("Gagal terhubung ke printer.");
        Get.snackbar(
          "Error",
          "Gagal terhubung ke printer.",
        );
      }
    } catch (e) {
      debugPrint("Error koneksi printer: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Putuskan koneksi printer
  Future<void> disconnectPrinter() async {
    try {
      await PrintBluetoothThermal.disconnect;
      isConnected.value = false;
      debugPrint("Printer terputus.");
    } catch (e) {
      debugPrint("Error saat memutus koneksi: $e");
    }
  }
}
