import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/activity_log_entity.dart';
import '../repositories/i_history_repository.dart';

class GetDiagnosticHistoryUseCase {
  final IHistoryRepository _repository;

  const GetDiagnosticHistoryUseCase(this._repository);

  Future<Result<List<ActivityLogEntity>, Failure>> call({String? filterCategory}) {
    return _repository.getDiagnosticHistory(filterCategory: filterCategory);
  }
}
