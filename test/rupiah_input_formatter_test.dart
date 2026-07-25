import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/core/utils/rupiah_input_formatter.dart';

void main() {
  test('format grup ribuan gaya id_ID', () {
    expect(formatRupiahDigits('9000'), '9.000');
    expect(formatRupiahDigits('1500000'), '1.500.000');
    expect(formatRupiahDigits('500'), '500');
    expect(formatRupiahDigits(''), '');
    expect(formatRupiahDigits('abc9x0x0x0'), '9.000'); // buang non-digit
  });

  test('formatter + parse balik konsisten (strip titik)', () {
    final f = RupiahInputFormatter();
    final result = f.formatEditUpdate(
      const TextEditingValue(text: '9000'),
      const TextEditingValue(text: '9000'),
    );
    expect(result.text, '9.000');
    // pemakai parsing: replaceAll('.', '') -> angka asli
    expect(double.parse(result.text.replaceAll('.', '')), 9000);
    // kursor di akhir
    expect(result.selection.baseOffset, result.text.length);
  });
}
