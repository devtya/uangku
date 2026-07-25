import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _idr = NumberFormat.decimalPattern('id_ID');

/// Format string angka jadi bergrup ribuan gaya Indonesia: "9000" -> "9.000".
/// Dipakai juga untuk mengisi nilai awal field edit.
String formatRupiahDigits(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return '';
  return _idr.format(int.parse(digits));
}

/// Formatter input: saat mengetik, angka otomatis dipisah titik ribuan.
/// Parsing tetap kompatibel karena semua pemakai memakai replaceAll('.', '').
class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = formatRupiahDigits(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
