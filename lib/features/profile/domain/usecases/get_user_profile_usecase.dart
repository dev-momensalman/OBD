import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/i_profile_repository.dart';

class GetUserProfileUseCase {
  final IProfileRepository _repository;

  const GetUserProfileUseCase(this._repository);

  Future<Result<UserProfileEntity, Failure>> call() {
    return _repository.getUserProfile();
  }
}
