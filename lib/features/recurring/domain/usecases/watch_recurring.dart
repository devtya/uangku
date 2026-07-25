import 'package:uangku/features/recurring/domain/entities/recurring_entity.dart';
import 'package:uangku/features/recurring/domain/repositories/recurring_repository.dart';

class WatchRecurring {
  final RecurringRepository repository;
  WatchRecurring(this.repository);

  Stream<List<RecurringEntity>> call() => repository.watchAll();
}
