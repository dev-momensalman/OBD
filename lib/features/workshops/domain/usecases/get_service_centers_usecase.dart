import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/service_center_entity.dart';
import '../repositories/i_workshops_repository.dart';

class GetServiceCentersUseCase {
  final IWorkshopsRepository _repository;

  const GetServiceCentersUseCase(this._repository);

  Future<Result<List<ServiceCenterEntity>, Failure>> call({String? query}) {
    return _repository.getServiceCenters(query: query);
  }
}
