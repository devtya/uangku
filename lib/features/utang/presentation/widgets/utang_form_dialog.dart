import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/core/utils/rupiah_input_formatter.dart';
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
  late final TextEditingController _totalController; // bulat: total, cicilan: pokok
  late final TextEditingController _tenorController;
  late final TextEditingController _bungaController;
  late final TextEditingController _catatanController;
  DateTime? _jatuhTempo;
  late DateTime _tanggalMulai;
  late String _jenis;

  final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  bool get isEditing => widget.existing != null;
  bool get isCicilan => _jenis == UtangJenis.cicilan;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _jenis = e?.jenis ?? UtangJenis.bulat;
    _namaController = TextEditingController(text: e?.namaUtang ?? '');
    _catatanController = TextEditingController(text: e?.catatan ?? '');
    _jatuhTempo = e?.jatuhTempo;
    _tanggalMulai = e?.tanggalMulai ?? DateTime.now();
    _tenorController = TextEditingController(text: e?.tenor?.toString() ?? '');
    _bungaController = TextEditingController(
        text: e?.bungaPersen == null ? '' : _trimNum(e!.bungaPersen!));

    // Untuk cicilan yang diedit, field jumlah menampilkan pokok (bukan total+bunga).
    String jumlahAwal = '';
    if (e != null) {
      final nilai = (e.isCicilan)
          ? e.jumlahTotal / (1 + (e.bungaPersen! / 100) * e.tenor!)
          : e.jumlahTotal;
      jumlahAwal = formatRupiahDigits(nilai.round().toString());
    }
    _totalController = TextEditingController(text: jumlahAwal);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _totalController.dispose();
    _tenorController.dispose();
    _bungaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  String _trimNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  double get _pokok =>
      double.tryParse(_totalController.text.replaceAll('.', '')) ?? 0;
  int get _tenor => int.tryParse(_tenorController.text.trim()) ?? 0;
  double get _bunga =>
      double.tryParse(_bungaController.text.trim().replaceAll(',', '.')) ?? 0;
  double get _totalBayar => _pokok + _pokok * (_bunga / 100) * _tenor;
  double get _cicilanBulan => _tenor > 0 ? _totalBayar / _tenor : 0;

  Future<void> _pickJatuhTempo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _jatuhTempo ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _jatuhTempo = picked);
  }

  Future<void> _pickTanggalMulai() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalMulai,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _tanggalMulai = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final catatan = _catatanController.text.trim().isEmpty
        ? null
        : _catatanController.text.trim();

    if (isCicilan) {
      Navigator.of(context).pop(UtangFormResult(
        namaUtang: _namaController.text.trim(),
        jumlahTotal: _totalBayar, // pokok + bunga
        jenis: UtangJenis.cicilan,
        tenor: _tenor,
        bungaPersen: _bunga,
        tanggalMulai: _tanggalMulai,
        catatan: catatan,
      ));
    } else {
      Navigator.of(context).pop(UtangFormResult(
        namaUtang: _namaController.text.trim(),
        jumlahTotal: _pokok,
        jenis: UtangJenis.bulat,
        jatuhTempo: _jatuhTempo,
        catatan: catatan,
      ));
    }
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
                const SizedBox(height: 20),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: UtangJenis.bulat, label: Text('Bulat')),
                    ButtonSegment(
                        value: UtangJenis.cicilan, label: Text('Cicilan')),
                  ],
                  selected: {_jenis},
                  onSelectionChanged: (s) => setState(() => _jenis = s.first),
                ),
                const SizedBox(height: 16),
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
                  inputFormatters: [RupiahInputFormatter()],
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: isCicilan ? 'Jumlah pinjaman (pokok)' : 'Jumlah total',
                    prefixText: 'Rp ',
                  ),
                  validator: (value) {
                    final parsed =
                        double.tryParse((value ?? '').replaceAll('.', ''));
                    if (parsed == null || parsed <= 0) {
                      return 'Jumlah harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (isCicilan) ..._cicilanFields(dateFormat) else _bulatFields(dateFormat),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _catatanController,
                  maxLines: 2,
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

  Widget _bulatFields(DateFormat dateFormat) {
    return InkWell(
      onTap: _pickJatuhTempo,
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
        child: Text(_jatuhTempo == null ? 'Tidak ada' : dateFormat.format(_jatuhTempo!)),
      ),
    );
  }

  List<Widget> _cicilanFields(DateFormat dateFormat) {
    return [
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _tenorController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Tenor',
                suffixText: 'bulan',
              ),
              validator: (v) {
                final t = int.tryParse((v ?? '').trim());
                if (t == null || t <= 0) return 'Tenor > 0';
                return null;
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _bungaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Bunga',
                suffixText: '%/bln',
              ),
              validator: (v) {
                final b = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                if (b == null || b < 0) return 'Tidak valid';
                return null;
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      InkWell(
        onTap: _pickTanggalMulai,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Tanggal mulai',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(dateFormat.format(_tanggalMulai)),
        ),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.tint,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cicilan/bulan: ${_rp.format(_cicilanBulan)}',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.colors.primary)),
            const SizedBox(height: 2),
            Text(
                'Total bayar ${_rp.format(_totalBayar)} · cicilan pertama ${DateFormat('d MMM yyyy', 'id_ID').format(DateTime(_tanggalMulai.year, _tanggalMulai.month + 1, _tanggalMulai.day))}',
                style: TextStyle(fontSize: 11, color: context.colors.textSecondary)),
          ],
        ),
      ),
    ];
  }
}

class UtangFormResult {
  final String namaUtang;
  final double jumlahTotal;
  final String jenis;
  final DateTime? jatuhTempo;
  final String? catatan;
  final int? tenor;
  final double? bungaPersen;
  final DateTime? tanggalMulai;

  const UtangFormResult({
    required this.namaUtang,
    required this.jumlahTotal,
    required this.jenis,
    this.jatuhTempo,
    this.catatan,
    this.tenor,
    this.bungaPersen,
    this.tanggalMulai,
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
