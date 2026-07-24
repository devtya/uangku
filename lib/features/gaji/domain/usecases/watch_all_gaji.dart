import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';
import 'package:uangku/features/gaji/domain/repositories/gaji_repository.dart';

class WatchAllGaji {
  final GajiRepository repository;
  WatchAllGaji(this.repository);

  Stream<List<GajiEntity>> call() => repository.watchAllGaji();
}
