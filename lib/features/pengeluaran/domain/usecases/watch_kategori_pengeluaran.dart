import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/kategori_repository.dart';

class WatchKategoriPengeluaran {
  final KategoriRepository repository;
  WatchKategoriPengeluaran(this.repository);

  Stream<List<KategoriEntity>> call() => repository.watchKategoriPengeluaran();
}
