import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/user_profile_entity.dart';

abstract class IProfileRepository {
  Future<Result<UserProfileEntity, Failure>> getUserProfile();
  Future<Result<void, Failure>> updateProfile(UserProfileEntity profile);
}
