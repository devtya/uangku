import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';

class GajiFormDialog extends StatefulWidget {
  final GajiEntity? existingGaji;

  const GajiFormDialog({super.key, this.existingGaji});

  @override
  State<GajiFormDialog> createState() => _GajiFormDialogState();
}

class _GajiFormDialogState extends State<GajiFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _jumlahController;
  late final TextEditingController _catatanController;
  late DateTime _selectedDate;

  bool get isEditing => widget.existingGaji != null;

  @override
  void initState() {
    super.initState();
    _jumlahController = TextEditingController(
      text: widget.existingGaji != null
          ? widget.existingGaji!.jumlah.toStringAsFixed(0)
          : '',
    );
    _catatanController = TextEditingController(
      text: widget.existingGaji?.catatan ?? '',
    );
    _selectedDate = widget.existingGaji?.tanggal ?? DateTime.now();
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final jumlah = double.parse(_jumlahController.text.replaceAll('.', ''));
    final catatan = _catatanController.text.trim().isEmpty
        ? null
        : _catatanController.text.trim();

    Navigator.of(context).pop(_GajiFormResult(
      jumlah: jumlah,
      tanggal: _selectedDate,
      catatan: catatan,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'Edit Gaji' : 'Tambah Gaji',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    prefixText: 'Rp ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan jumlah gaji';
                    }
                    final parsed = double.tryParse(value.replaceAll('.', ''));
                    if (parsed == null || parsed <= 0) {
                      return 'Jumlah harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(dateFormat.format(_selectedDate)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _catatanController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (opsional)',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _submit,
                      child: Text(isEditing ? 'Simpan' : 'Tambah'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GajiFormResult {
  final double jumlah;
  final DateTime tanggal;
  final String? catatan;

  const _GajiFormResult({
    required this.jumlah,
    required this.tanggal,
    this.catatan,
  });
}

Future<_GajiFormResult?> showGajiFormDialog(
  BuildContext context, {
  GajiEntity? existingGaji,
}) {
  return showDialog<_GajiFormResult>(
    context: context,
    builder: (_) => GajiFormDialog(existingGaji: existingGaji),
  );
}
