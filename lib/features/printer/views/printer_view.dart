import 'package:cashier/features/printer/bloc/printer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class PrinterView extends StatelessWidget {
  const PrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrinterBloc, PrinterState>(
      listener: (context, state) {
        if (state is PrinterFailed) {
          Get.snackbar("Error", state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Printer"),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<PrinterBloc>().add(ScanPrinter());
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<PrinterBloc, PrinterState>(
            builder: (context, state) {
              if (state is PrinterLoading) {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state is PrinterSuccess && state.isLoading == true) {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state is PrinterFailed) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text(state.message)),
                    ElevatedButton(
                        onPressed: () {
                          context.read<PrinterBloc>().add(ScanPrinter());
                        },
                        child: Text("Scan Printer"))
                  ],
                );
              }
              if (state is PrinterSuccess) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.devices.length,
                        itemBuilder: (context, index) {
                          final data = state.devices[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: data.macAdress == state.connectedDeviceId
                                  ? Colors.green
                                  : null,
                              child: ListTile(
                                trailing: Text(
                                    state.connectedDeviceId == data.macAdress
                                        ? "Connected"
                                        : ""),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            textAlign: TextAlign.center,
                                            "Tekan 3 detik untuk sambungkan printer"),
                                      );
                                    },
                                  );
                                  // context.read<PrinterBloc>().add(
                                  //     SelectPrinter(macAddress: data.macAdress));
                                },
                                onLongPress: () {
                                  context.read<PrinterBloc>().add(
                                      ConnectPrinter(
                                          macAddress: data.macAdress));
                                },
                                title: Text(data.name),
                                subtitle: Text(data.macAdress),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Text("Ditemukan ${state.devices.length} perangkat"),
                  ],
                );
              }
              return Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        context.read<PrinterBloc>().add(ScanPrinter());
                      },
                      child: Text("Scan Printer"))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
