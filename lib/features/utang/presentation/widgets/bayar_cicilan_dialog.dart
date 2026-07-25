import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

class BayarCicilanDialog extends StatefulWidget {
  final UtangEntity utang;

  const BayarCicilanDialog({super.key, required this.utang});

  @override
  State<BayarCicilanDialog> createState() => _BayarCicilanDialogState();
}

class _BayarCicilanDialogState extends State<BayarCicilanDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _jumlahText;
  late DateTime _tanggal;

  @override
  void initState() {
    super.initState();
    // Default: sisa utang (bayar lunas sekaligus), tetap bisa diubah.
    _jumlahText = widget.utang.sisaUtang.toStringAsFixed(0);
    _tanggal = DateTime.now();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _tanggal = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final jumlah = double.parse(_jumlahText.replaceAll('.', ''));
    Navigator.of(context).pop(BayarCicilanResult(jumlah: jumlah, tanggal: _tanggal));
  }

  @override
  Widget build(BuildContext context) {
    final rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
    final sisa = widget.utang.sisaUtang;

    return AlertDialog(
      title: const Text('Bayar Cicilan'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${widget.utang.namaUtang} · sisa ${rp.format(sisa)}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _jumlahText,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Jumlah bayar',
                prefixText: 'Rp ',
              ),
              onChanged: (v) => _jumlahText = v,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan jumlah bayar';
                }
                final parsed = double.tryParse(value.replaceAll('.', ''));
                if (parsed == null || parsed <= 0) {
                  return 'Jumlah harus lebih dari 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(dateFormat.format(_tanggal)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Bayar'),
        ),
      ],
    );
  }
}

class BayarCicilanResult {
  final double jumlah;
  final DateTime tanggal;

  const BayarCicilanResult({required this.jumlah, required this.tanggal});
}

Future<BayarCicilanResult?> showBayarCicilanDialog(
  BuildContext context, {
  required UtangEntity utang,
}) {
  return showDialog<BayarCicilanResult>(
    context: context,
    builder: (_) => BayarCicilanDialog(utang: utang),
  );
}
