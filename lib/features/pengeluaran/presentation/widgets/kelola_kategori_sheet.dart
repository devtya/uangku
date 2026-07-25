import 'package:flutter/material.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/add_kategori.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/delete_kategori.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/update_kategori.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_kategori_pengeluaran.dart';

Future<void> showKelolaKategoriSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _KelolaKategoriSheet(),
  );
}

class _KelolaKategoriSheet extends StatelessWidget {
  const _KelolaKategoriSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  tooltip: 'Kembali',
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Expanded(
                  child: Text('Kelola Kategori',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                TextButton.icon(
                  onPressed: () => _promptTambah(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: StreamBuilder<List<KategoriEntity>>(
                stream: sl<WatchKategoriPengeluaran>()(),
                builder: (context, snapshot) {
                  final list = snapshot.data ?? const <KategoriEntity>[];
                  if (list.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text('Belum ada kategori',
                            style: TextStyle(
                                fontSize: 13, color: context.colors.textSecondary)),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: context.colors.divider),
                    itemBuilder: (_, i) => _row(context, list[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, KategoriEntity k) {
    final terkunci = k.nama == kKategoriCicilanUtang;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(k.nama,
                style: TextStyle(
                    fontSize: 14, color: context.colors.textPrimary)),
          ),
          if (terkunci)
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.lock_outline,
                  size: 18, color: context.colors.textMuted),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              color: context.colors.textSecondary,
              tooltip: 'Ubah nama',
              onPressed: () => _promptRename(context, k),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: context.colors.textMuted,
              tooltip: 'Hapus',
              onPressed: () => _confirmDelete(context, k),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _promptTambah(BuildContext context) async {
    final nama = await _promptNama(context, title: 'Kategori Baru');
    if (nama != null) await sl<AddKategori>()(nama);
  }

  Future<void> _promptRename(BuildContext context, KategoriEntity k) async {
    final nama =
        await _promptNama(context, title: 'Ubah Nama Kategori', initial: k.nama);
    if (nama != null && nama != k.nama) {
      await sl<UpdateKategori>()(k.id, nama);
    }
  }

  Future<void> _confirmDelete(BuildContext context, KategoriEntity k) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text(
            'Hapus kategori "${k.nama}"? Pengeluaran lama yang memakainya akan '
            'ditampilkan tanpa kategori.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) await sl<DeleteKategori>()(k.id);
  }

  /// Dialog input nama (pola aman: onChanged ke String, tanpa controller).
  Future<String?> _promptNama(BuildContext context,
      {required String title, String? initial}) async {
    var nama = initial ?? '';
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextFormField(
          initialValue: initial,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nama kategori'),
          onChanged: (v) => nama = v,
          onFieldSubmitted: (v) {
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
    return (result != null && result.isNotEmpty) ? result : null;
  }
}
