import 'package:cashier/utils/my_elevated.dart';
import 'package:cashier/utils/no_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/printer_controller.dart';

class PrinterView extends GetView<PrinterController> {
  const PrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Printers"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Scan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() => myElevated(
                      onPress: controller.isScanning.value
                          ? null
                          : controller.scanDevices, // Disable saat scanning
                      child: controller.isScanning.value
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text("Mencari..."),
                              ],
                            )
                          : Text("Cari Printer"),
                    )),
                // Tombol Connect & Disconnect
                Obx(() => controller.isConnected.value
                    ? ElevatedButton(
                        onPressed: controller.disconnectPrinter,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text("Putuskan"),
                      )
                    : myElevated(
                        onPress: controller.connectToPrinter,
                        child: controller.isLoading.value
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text("Menyambungkan..."),
                                ],
                              )
                            : Text("Sambungkan"),
                      )),
              ],
            ),

            SizedBox(height: 16),

            // List Printer
            Obx(() => Expanded(
                  child:
                      controller.devices.isEmpty && !controller.isScanning.value
                          ? Center(
                              child: noData(
                                  icon: Icons.print_disabled,
                                  title: "Tidak ada printer ditemukan.",
                                  message: 'Tekan tombol "Cari Printer"'))
                          : ListView.builder(
                              itemCount: controller.devices.length,
                              itemBuilder: (context, index) {
                                final printer = controller.devices[index];
                                return Obx(() => Card(
                                      color: controller.selectedPrinter.value ==
                                              printer
                                          ? Colors.greenAccent
                                          : Colors.white,
                                      child: ListTile(
                                        title: Text(printer.name),
                                        subtitle: Text(printer.macAdress),
                                        // trailing:
                                        //     controller.selectedPrinter.value ==
                                        //             printer
                                        //         ? Icon(Icons.radio_button_checked,
                                        //             color: Colors.green)
                                        //         : null,
                                        onTap: () {
                                          controller.selectedPrinter.value =
                                              printer;
                                        },
                                      ),
                                    ));
                              },
                            ),
                )),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
