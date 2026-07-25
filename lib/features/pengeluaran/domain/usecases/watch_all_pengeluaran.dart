import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';

class WatchAllPengeluaran {
  final PengeluaranRepository repository;
  WatchAllPengeluaran(this.repository);

  Stream<List<PengeluaranEntity>> call() => repository.watchAllPengeluaran();
}
