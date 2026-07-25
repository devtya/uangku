import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';

/// Konsumsi lintas-fitur: history pembayaran cicilan sebuah utang diambil dari
/// entry Pengeluaran (via PengeluaranRepository), bukan repo saling panggil.
class WatchCicilanByUtang {
  final PengeluaranRepository _pengeluaranRepository;
  WatchCicilanByUtang(this._pengeluaranRepository);

  Stream<List<PengeluaranEntity>> call(String utangId) =>
      _pengeluaranRepository.watchByUtangId(utangId);
}
