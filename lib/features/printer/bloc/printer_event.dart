part of 'printer_bloc.dart';

sealed class PrinterEvent extends Equatable {
  const PrinterEvent();

  @override
  List<Object> get props => [];
}

final class ScanPrinter extends PrinterEvent {}

final class ConnectPrinter extends PrinterEvent {
  final String macAddress;

  const ConnectPrinter({required this.macAddress});

  @override
  List<Object> get props => [macAddress];
}

final class SelectPrinter extends PrinterEvent {
  final String macAddress;

  const SelectPrinter({required this.macAddress});
  @override
  List<Object> get props => [macAddress];
}

final class DisconnectPrinter extends PrinterEvent {}
