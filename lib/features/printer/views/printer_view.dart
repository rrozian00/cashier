import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/printer_controller.dart';

class PrinterView extends GetView<PrinterController> {
  const PrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Printer"),
        actions: [
          IconButton(
              onPressed: () {
                //
              },
              icon: Icon(Icons.refresh)),
          // ElevatedButton(
          //     onPressed: () {
          //       showMysnackbar(context, "Error", "test ini");
          //     },
          //     child: Text("test"))
        ],
      ),
      body: SafeArea(child: Obx(() {
        if (controller.isLoading.value == true) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (controller.printerList.isEmpty) {
          return Center(child: Text("Tidak ada printer yang ditemukan"));
        }
        if (controller.printerList.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.printerList.length,
                  itemBuilder: (context, index) {
                    final data = controller.printerList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: data.macAdress == controller.connectedDeviceId
                            ? Colors.green
                            : null,
                        child: ListTile(
                          trailing:
                              controller.connectedDeviceId == data.macAdress
                                  ? Text("Tersambung")
                                  : null,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                      textAlign: TextAlign.center,
                                      "Tekan dan tahan 2 detik untuk sambungkan printer"),
                                );
                              },
                            );
                          },
                          onLongPress: () {
                            //
                          },
                          title: Text(data.name),
                          subtitle: Text(data.macAdress),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text("Ditemukan ${controller.printerList.length} perangkat"),
            ],
          );
        }
        return Center(
          child: ElevatedButton(
              onPressed: () {
                //
              },
              child: Text("Cari Printer")),
        );
      })),
    );
  }
}
