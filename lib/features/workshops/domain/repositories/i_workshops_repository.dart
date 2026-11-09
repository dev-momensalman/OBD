import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/service_center_entity.dart';

abstract class IWorkshopsRepository {
  Future<Result<List<ServiceCenterEntity>, Failure>> getServiceCenters({String? query});
  Future<Result<ServiceCenterEntity, Failure>> getServiceCenterById(String id);
}
