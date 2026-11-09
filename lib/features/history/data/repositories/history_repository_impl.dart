import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../../domain/entities/activity_log_entity.dart';
import '../../domain/repositories/i_history_repository.dart';
import '../datasources/history_remote_datasource.dart';

class HistoryRepositoryImpl implements IHistoryRepository {
  final IHistoryRemoteDataSource _remoteDataSource;

  const HistoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ActivityLogEntity>, Failure>> getDiagnosticHistory({String? filterCategory}) async {
    try {
      final models = await _remoteDataSource.getDiagnosticHistory(filterCategory: filterCategory);
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Err(ServerFailure('Failed to fetch diagnostic history: $e'));
    }
  }
}
