import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UserProfileEntity, Failure>> getUserProfile() async {
    try {
      final model = await _remoteDataSource.getUserProfile();
      return Success(model.toEntity());
    } catch (e) {
      return Err(ServerFailure('Failed to load user profile: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> updateProfile(UserProfileEntity profile) async {
    try {
      final model = UserProfileModel(
        id: profile.id,
        username: profile.username,
        email: profile.email,
        displayName: profile.displayName,
        avatarUrl: profile.avatarUrl,
        vehicleName: profile.vehicleName,
        deviceSerial: profile.deviceSerial,
        preferredLanguage: profile.preferredLanguage,
      );
      await _remoteDataSource.updateProfile(model);
      return const Success(null);
    } catch (e) {
      return Err(ServerFailure('Failed to update user profile: $e'));
    }
  }
}
