import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final MobileScannerController controller = MobileScannerController();

  final List<String> barcodes = [];

  bool isDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          Navigator.pop(
            context,
            barcodes,
          );
        },
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) async {
                if (isDetected) return;

                final barcode = capture.barcodes.first.rawValue ?? '';

                if (barcode.isEmpty) return;

                isDetected = true;

                // hindari duplicate
                if (!barcodes.contains(barcode)) {
                  setState(() {
                    barcodes.add(barcode);
                  });
                }
                HapticFeedback.mediumImpact();
                await SystemSound.play(SystemSoundType.click);
                // setState(() {
                //   barcodes.add(barcode);
                // });

                await Future.delayed(
                  const Duration(milliseconds: 800),
                );

                isDetected = false;
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: barcodes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12),
                  child: Card(
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(
                        barcodes[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
