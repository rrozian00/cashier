part of 'printer_bloc.dart';

sealed class PrinterState extends Equatable {
  const PrinterState();

  @override
  List<Object> get props => [];
}

final class PrinterInitial extends PrinterState {}

final class PrinterLoading extends PrinterState {}

class PrinterSuccess extends PrinterState {
  final List<BluetoothInfo> devices;
  final String selectedDeviceId;
  final String connectedDeviceId;
  final bool isLoading;

  const PrinterSuccess({
    required this.devices,
    required this.isLoading,
    required this.selectedDeviceId,
    required this.connectedDeviceId,
  });

  PrinterSuccess copyWith({
    List<BluetoothInfo>? devices,
    String? selectedDeviceId,
    String? connectedDeviceId,
    bool? isLoading,
  }) {
    return PrinterSuccess(
      isLoading: isLoading ?? this.isLoading,
      devices: devices ?? this.devices,
      selectedDeviceId: selectedDeviceId ?? this.selectedDeviceId,
      connectedDeviceId: connectedDeviceId ?? this.connectedDeviceId,
    );
  }

  // bool get isDeviceSelected => selectedDeviceId != null;
  // bool get isDeviceConnected => connectedDeviceId != null;

  @override
  List<Object> get props =>
      [isLoading, devices, selectedDeviceId, connectedDeviceId];
}

// final class ScanPrinterSuccess extends PrinterState {
//   final List<BluetoothInfo> printers;

//   const ScanPrinterSuccess({required this.printers});
//   @override
//   List<Object> get props => [printers];
// }

final class PrinterFailed extends PrinterState {
  final String message;

  const PrinterFailed({required this.message});
  @override
  List<Object> get props => [message];
}
