import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../../domain/entities/service_center_entity.dart';
import '../../domain/repositories/i_workshops_repository.dart';
import '../datasources/workshops_remote_datasource.dart';

class WorkshopsRepositoryImpl implements IWorkshopsRepository {
  final IWorkshopsRemoteDataSource _remoteDataSource;

  const WorkshopsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ServiceCenterEntity>, Failure>> getServiceCenters({String? query}) async {
    try {
      final models = await _remoteDataSource.getServiceCenters(query: query);
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Err(ServerFailure('Failed to fetch service centers: $e'));
    }
  }

  @override
  Future<Result<ServiceCenterEntity, Failure>> getServiceCenterById(String id) async {
    try {
      final model = await _remoteDataSource.getServiceCenterById(id);
      return Success(model.toEntity());
    } catch (e) {
      return Err(ServerFailure('Failed to fetch service center: $e'));
    }
  }
}
