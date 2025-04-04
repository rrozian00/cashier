import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatelessWidget {
  ScannerPage({super.key});

  final isScanned = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: SafeArea(
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: MobileScanner(
            controller: MobileScannerController(),
            onDetect: (BarcodeCapture capture) {
              if (!isScanned()) {
                isScanned(true); // Tandai sudah scan
                final result = capture.barcodes.first.rawValue ?? "";
                if (result.isNotEmpty) {
                  Get.back(result: result); // Kembalikan hasil scan
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
