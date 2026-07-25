import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

class UtangFormDialog extends StatefulWidget {
  final UtangEntity? existing;

  const UtangFormDialog({super.key, this.existing});

  @override
  State<UtangFormDialog> createState() => _UtangFormDialogState();
}

class _UtangFormDialogState extends State<UtangFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _totalController;
  late final TextEditingController _catatanController;
  DateTime? _jatuhTempo;

  bool get isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.existing?.namaUtang ?? '');
    _totalController = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.jumlahTotal.toStringAsFixed(0)
          : '',
    );
    _catatanController =
        TextEditingController(text: widget.existing?.catatan ?? '');
    _jatuhTempo = widget.existing?.jatuhTempo;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _totalController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _jatuhTempo ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _jatuhTempo = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final total = double.parse(_totalController.text.replaceAll('.', ''));
    final catatan = _catatanController.text.trim().isEmpty
        ? null
        : _catatanController.text.trim();

    Navigator.of(context).pop(UtangFormResult(
      namaUtang: _namaController.text.trim(),
      jumlahTotal: total,
      jatuhTempo: _jatuhTempo,
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
                  isEditing ? 'Edit Utang' : 'Tambah Utang',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama utang'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Masukkan nama utang'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah total',
                    prefixText: 'Rp ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan jumlah total';
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
                    decoration: InputDecoration(
                      labelText: 'Jatuh tempo (opsional)',
                      suffixIcon: _jatuhTempo == null
                          ? const Icon(Icons.calendar_today)
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setState(() => _jatuhTempo = null),
                            ),
                    ),
                    child: Text(
                      _jatuhTempo == null
                          ? 'Tidak ada'
                          : dateFormat.format(_jatuhTempo!),
                    ),
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

class UtangFormResult {
  final String namaUtang;
  final double jumlahTotal;
  final DateTime? jatuhTempo;
  final String? catatan;

  const UtangFormResult({
    required this.namaUtang,
    required this.jumlahTotal,
    this.jatuhTempo,
    this.catatan,
  });
}

Future<UtangFormResult?> showUtangFormDialog(
  BuildContext context, {
  UtangEntity? existing,
}) {
  return showDialog<UtangFormResult>(
    context: context,
    builder: (_) => UtangFormDialog(existing: existing),
  );
}
