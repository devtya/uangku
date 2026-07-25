import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/utils/rupiah_input_formatter.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_kategori_pengeluaran.dart';
import 'package:uangku/features/recurring/domain/entities/recurring_entity.dart';

class RecurringFormDialog extends StatefulWidget {
  final RecurringEntity? existing;
  const RecurringFormDialog({super.key, this.existing});

  @override
  State<RecurringFormDialog> createState() => _RecurringFormDialogState();
}

class _RecurringFormDialogState extends State<RecurringFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nominalController;
  late final TextEditingController _bebasController;
  late final TextEditingController _sumberController;
  late final TextEditingController _catatanController;
  late String _tipe;
  late String _frekuensi;
  late DateTime _tanggalMulai;
  DateTime? _tanggalAkhir;
  String? _kategoriId;
  late bool _aktif;

  bool get isEditing => widget.existing != null;
  bool get isPendapatan => _tipe == RecurringTipe.pendapatan;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _tipe = e?.tipe ?? RecurringTipe.pendapatan;
    _frekuensi = e?.frekuensi ?? RecurringFrekuensi.harian;
    _tanggalMulai = e?.tanggalMulai ?? DateTime.now();
    _tanggalAkhir = e?.tanggalAkhir;
    _kategoriId = e?.kategoriId;
    _aktif = e?.aktif ?? true;
    _nominalController = TextEditingController(
        text: e == null ? '' : formatRupiahDigits(e.nominal.toStringAsFixed(0)));
    _bebasController = TextEditingController(
        text: e?.nominalBebas == null
            ? ''
            : formatRupiahDigits(e!.nominalBebas!.toStringAsFixed(0)));
    _sumberController = TextEditingController(text: e?.sumber ?? '');
    _catatanController = TextEditingController(text: e?.catatan ?? '');
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _bebasController.dispose();
    _sumberController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  double _parse(String s) => double.tryParse(s.replaceAll('.', '').trim()) ?? 0;

  Future<void> _pickTanggal(bool mulai) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (mulai ? _tanggalMulai : _tanggalAkhir) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => mulai ? _tanggalMulai = picked : _tanggalAkhir = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!isPendapatan && _kategoriId == null) return;
    final e = widget.existing;
    final bebasTxt = _bebasController.text.trim();
    Navigator.of(context).pop(RecurringEntity(
      id: e?.id ?? const Uuid().v4(),
      tipe: _tipe,
      nominal: _parse(_nominalController.text),
      nominalBebas: (isPendapatan && bebasTxt.isNotEmpty) ? _parse(bebasTxt) : null,
      frekuensi: _frekuensi,
      tanggalMulai: _tanggalMulai,
      tanggalAkhir: _tanggalAkhir,
      terakhirDibuat: e?.terakhirDibuat,
      sumber: isPendapatan
          ? (_sumberController.text.trim().isEmpty
              ? null
              : _sumberController.text.trim())
          : null,
      kategoriId: isPendapatan ? null : _kategoriId,
      catatan: _catatanController.text.trim().isEmpty
          ? null
          : _catatanController.text.trim(),
      aktif: _aktif,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM yyyy', 'id_ID');
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
                Text(isEditing ? 'Edit Berulang' : 'Tambah Berulang',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                        value: RecurringTipe.pendapatan,
                        label: Text('Pendapatan')),
                    ButtonSegment(
                        value: RecurringTipe.pengeluaran,
                        label: Text('Pengeluaran')),
                  ],
                  selected: {_tipe},
                  onSelectionChanged: (s) => setState(() => _tipe = s.first),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [RupiahInputFormatter()],
                  decoration:
                      const InputDecoration(labelText: 'Nominal', prefixText: 'Rp '),
                  validator: (v) {
                    final p = double.tryParse((v ?? '').replaceAll('.', ''));
                    return (p == null || p <= 0) ? 'Nominal > 0' : null;
                  },
                ),
                const SizedBox(height: 16),
                if (isPendapatan) ..._pendapatanFields() else _kategoriDropdown(),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _frekuensi,
                  decoration: const InputDecoration(labelText: 'Frekuensi'),
                  items: const [
                    DropdownMenuItem(
                        value: RecurringFrekuensi.harian, child: Text('Harian')),
                    DropdownMenuItem(
                        value: RecurringFrekuensi.mingguan,
                        child: Text('Mingguan')),
                    DropdownMenuItem(
                        value: RecurringFrekuensi.bulanan,
                        child: Text('Bulanan')),
                  ],
                  onChanged: (v) => setState(() => _frekuensi = v!),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickTanggal(true),
                        child: InputDecorator(
                          decoration:
                              const InputDecoration(labelText: 'Mulai'),
                          child: Text(df.format(_tanggalMulai)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickTanggal(false),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Berakhir (opsional)',
                            suffixIcon: _tanggalAkhir == null
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () =>
                                        setState(() => _tanggalAkhir = null),
                                  ),
                          ),
                          child: Text(_tanggalAkhir == null
                              ? 'Tanpa batas'
                              : df.format(_tanggalAkhir!)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aktif'),
                  value: _aktif,
                  onChanged: (v) => setState(() => _aktif = v),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Batal')),
                    const SizedBox(width: 12),
                    FilledButton(
                        onPressed: _submit,
                        child: Text(isEditing ? 'Simpan' : 'Tambah')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _pendapatanFields() {
    return [
      TextFormField(
        controller: _sumberController,
        decoration: const InputDecoration(
            labelText: 'Sumber (mis. Uang kopi)'),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _bebasController,
        keyboardType: TextInputType.number,
        inputFormatters: [RupiahInputFormatter()],
        decoration: const InputDecoration(
          labelText: 'Bebas dipakai (opsional)',
          prefixText: 'Rp ',
          helperText: 'Kosongkan jika seluruhnya bebas dipakai',
        ),
      ),
    ];
  }

  Widget _kategoriDropdown() {
    return StreamBuilder<List<KategoriEntity>>(
      stream: sl<WatchKategoriPengeluaran>()(),
      builder: (context, snapshot) {
        final kategori = snapshot.data ?? const <KategoriEntity>[];
        final ids = kategori.map((k) => k.id).toSet();
        final value = ids.contains(_kategoriId) ? _kategoriId : null;
        return DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Kategori'),
          validator: (v) => v == null ? 'Pilih kategori' : null,
          items: [
            for (final k in kategori)
              DropdownMenuItem(value: k.id, child: Text(k.nama)),
          ],
          onChanged: (v) => setState(() => _kategoriId = v),
        );
      },
    );
  }
}

Future<RecurringEntity?> showRecurringFormDialog(
  BuildContext context, {
  RecurringEntity? existing,
}) {
  return showDialog<RecurringEntity>(
    context: context,
    builder: (_) => RecurringFormDialog(existing: existing),
  );
}
