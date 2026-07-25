import 'package:uangku/features/utang/domain/entities/utang_entity.dart';
import 'package:uangku/features/utang/domain/repositories/utang_repository.dart';

class WatchAllUtang {
  final UtangRepository repository;
  WatchAllUtang(this.repository);

  Stream<List<UtangEntity>> call() => repository.watchAllUtang();
}
