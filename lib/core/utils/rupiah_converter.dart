import 'package:intl/intl.dart';

String rupiahConverter(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0, // Jika tidak ingin ada angka desimal
  );
  return formatter.format(amount);
}

String rupiahConverterDouble(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0, // If you don't want decimals, change this to 0
  );
  return formatter.format(amount);
}
