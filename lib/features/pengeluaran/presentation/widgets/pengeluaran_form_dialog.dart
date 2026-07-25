import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/utils/rupiah_input_formatter.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/add_kategori.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_kategori_pengeluaran.dart';

const _addKategoriSentinel = '__add_kategori__';

class PengeluaranFormDialog extends StatefulWidget {
  final PengeluaranEntity? existing;

  const PengeluaranFormDialog({super.key, this.existing});

  @override
  State<PengeluaranFormDialog> createState() => _PengeluaranFormDialogState();
}

class _PengeluaranFormDialogState extends State<PengeluaranFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _jumlahController;
  late final TextEditingController _catatanController;
  late DateTime _selectedDate;
  String? _kategoriId;

  // Nama kategori yang baru ditambahkan, untuk auto-select saat stream update.
  String? _pendingKategoriNama;

  bool get isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _jumlahController = TextEditingController(
      text: widget.existing != null
          ? formatRupiahDigits(widget.existing!.jumlah.toStringAsFixed(0))
          : '',
    );
    _catatanController = TextEditingController(
      text: widget.existing?.catatan ?? '',
    );
    _selectedDate = widget.existing?.tanggal ?? DateTime.now();
    _kategoriId = widget.existing?.kategoriId;
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

  Future<void> _addKategoriDialog() async {
    var nama = '';
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kategori Baru'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nama kategori'),
          onChanged: (v) => nama = v,
          onSubmitted: (v) {
            if (v.trim().isNotEmpty) Navigator.of(ctx).pop(v.trim());
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (nama.trim().isNotEmpty) Navigator.of(ctx).pop(nama.trim());
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    await sl<AddKategori>()(result);
    if (!mounted) return;
    // Stream kategori akan emit; tandai untuk auto-select begitu muncul.
    setState(() => _pendingKategoriNama = result);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_kategoriId == null) return;
    final jumlah = double.parse(_jumlahController.text.replaceAll('.', ''));
    final catatan = _catatanController.text.trim().isEmpty
        ? null
        : _catatanController.text.trim();

    Navigator.of(context).pop(PengeluaranFormResult(
      jumlah: jumlah,
      kategoriId: _kategoriId!,
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
                  isEditing ? 'Edit Pengeluaran' : 'Tambah Pengeluaran',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [RupiahInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    prefixText: 'Rp ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan jumlah pengeluaran';
                    }
                    final parsed = double.tryParse(value.replaceAll('.', ''));
                    if (parsed == null || parsed <= 0) {
                      return 'Jumlah harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _kategoriDropdown(),
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

  Widget _kategoriDropdown() {
    return StreamBuilder<List<KategoriEntity>>(
      stream: sl<WatchKategoriPengeluaran>()(),
      builder: (context, snapshot) {
        final kategori = snapshot.data ?? const <KategoriEntity>[];

        // Auto-select kategori yang baru ditambahkan begitu muncul di stream.
        if (_pendingKategoriNama != null) {
          final match = kategori
              .where((k) => k.nama == _pendingKategoriNama)
              .cast<KategoriEntity?>()
              .firstWhere((_) => true, orElse: () => null);
          if (match != null) {
            _kategoriId = match.id;
            _pendingKategoriNama = null;
          }
        }

        // Jaga agar value tetap valid (mis. kategori terpilih terhapus).
        final ids = kategori.map((k) => k.id).toSet();
        final value = ids.contains(_kategoriId) ? _kategoriId : null;

        return DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Kategori'),
          validator: (v) => v == null ? 'Pilih kategori' : null,
          items: [
            ...kategori.map(
              (k) => DropdownMenuItem(value: k.id, child: Text(k.nama)),
            ),
            const DropdownMenuItem(
              value: _addKategoriSentinel,
              child: Text('+ Tambah kategori'),
            ),
          ],
          onChanged: (v) {
            if (v == _addKategoriSentinel) {
              _addKategoriDialog();
            } else {
              setState(() => _kategoriId = v);
            }
          },
        );
      },
    );
  }
}

class PengeluaranFormResult {
  final double jumlah;
  final String kategoriId;
  final DateTime tanggal;
  final String? catatan;

  const PengeluaranFormResult({
    required this.jumlah,
    required this.kategoriId,
    required this.tanggal,
    this.catatan,
  });
}

Future<PengeluaranFormResult?> showPengeluaranFormDialog(
  BuildContext context, {
  PengeluaranEntity? existing,
}) {
  return showDialog<PengeluaranFormResult>(
    context: context,
    builder: (_) => PengeluaranFormDialog(existing: existing),
  );
}
