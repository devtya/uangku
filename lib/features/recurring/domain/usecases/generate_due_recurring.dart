import 'package:uuid/uuid.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';
import 'package:uangku/features/gaji/domain/repositories/gaji_repository.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';
import 'package:uangku/features/recurring/domain/repositories/recurring_repository.dart';

/// Orkestrasi: buat entri Pendapatan/Pengeluaran untuk semua occurrence
/// berulang yang terlewat, lalu update penanda terakhirDibuat.
class GenerateDueRecurring {
  final RecurringRepository _recurringRepository;
  final GajiRepository _gajiRepository;
  final PengeluaranRepository _pengeluaranRepository;

  GenerateDueRecurring(
    this._recurringRepository,
    this._gajiRepository,
    this._pengeluaranRepository,
  );

  Future<void> call() async {
    final now = DateTime.now();
    final rules = await _recurringRepository.getActive();
    for (final r in rules) {
      final due = r.occurrencesDue(now);
      if (due.isEmpty) continue;

      for (final tanggal in due) {
        if (r.isPendapatan) {
          await _gajiRepository.addGaji(GajiEntity(
            id: const Uuid().v4(),
            jumlah: r.nominal,
            jumlahBebas: r.nominalBebas ?? r.nominal,
            tanggal: tanggal,
            catatan: r.sumber,
          ));
        } else {
          if (r.kategoriId == null) continue;
          await _pengeluaranRepository.addPengeluaran(PengeluaranEntity(
            id: const Uuid().v4(),
            jumlah: r.nominal,
            kategoriId: r.kategoriId!,
            tanggal: tanggal,
            catatan: r.catatan,
          ));
        }
      }
      await _recurringRepository.update(r.copyWith(terakhirDibuat: due.last));
    }
  }
}
