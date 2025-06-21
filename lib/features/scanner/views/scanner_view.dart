import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isDetected = false;
  final MobileScannerController _controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: SafeArea(
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) {
              if (_isDetected) return; // cegah deteksi ulang
              final result = capture.barcodes.first.rawValue ?? "";
              if (result.isNotEmpty) {
                _isDetected = true;
                if (context.mounted) {
                  Navigator.pop(context, result);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
