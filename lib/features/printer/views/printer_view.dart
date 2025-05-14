import '../../../core/theme/colors.dart';
import '../../../core/widgets/my_appbar.dart';
import '../../../core/widgets/my_elevated.dart';
import '../../../core/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/printer_controller.dart';

class PrinterView extends GetView<PrinterController> {
  const PrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.isConnected.value;
    return Scaffold(
      backgroundColor: softGrey,
      appBar: MyAppBar(
        titleText: "Printer",
      ),
      body: Obx(
        () {
          if (controller.isConnected.isTrue) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.print_rounded,
                  color: green,
                  size: 100,
                ),
                Center(
                  child: Text(
                    "Terhubung dengan ${controller.selectedPrinter.value?.name}",
                    style: TextStyle(color: green),
                  ),
                ),
              ],
            );
          }

          if (controller.devices.isEmpty) {
            return Center(
              child: noData(
                  icon: Icons.print_disabled_rounded,
                  title: "Tidak ada Printer",
                  message: 'Tekan tombol "Cari Printer"'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),

                // List Printer
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.67,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.devices.length,
                          itemBuilder: (context, index) {
                            final printer = controller.devices[index];
                            return Obx(() => Card(
                                  elevation: 4,
                                  color: controller.selectedPrinter.value ==
                                          printer
                                      ? Colors.greenAccent
                                      : Colors.white,
                                  child: ListTile(
                                    title: Text(printer.name),
                                    subtitle: Text(printer.macAdress),
                                    onTap: () {
                                      controller.selectedPrinter.value =
                                          printer;
                                    },
                                  ),
                                ));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text('Silahkan pilih Printer, lalu "Hubungkan"')
                    ],
                  ),
                ),

                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: // Tombol Scan
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() => myElevated(
                height: 50,
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
                            child: CircularProgressIndicator.adaptive(
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
              ? myRedElevated(
                  onPress: controller.disconnectPrinter,
                  text: "Putuskan",
                  // style: TextStyle(color: white),
                )
              : myElevated(
                  height: 50,
                  onPress: controller.connectToPrinter,
                  child: controller.isLoading.value
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text("Menghubungkan..."),
                          ],
                        )
                      : Text("Hubungkan"),
                )),
        ],
      ),
    );
  }
}
