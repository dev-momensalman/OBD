import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/activity_log_entity.dart';

abstract class IHistoryRepository {
  Future<Result<List<ActivityLogEntity>, Failure>> getDiagnosticHistory({String? filterCategory});
}
