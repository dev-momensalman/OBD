import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class UpdatePasswordUseCase {
  final IAuthRepository _repository;

  const UpdatePasswordUseCase(this._repository);

  Future<Result<UserEntity, Failure>> call({
    required String newPassword,
    bool isArabic = false,
  }) async {
    if (newPassword.length < 8) {
      return Err(AuthFailure(
        isArabic
            ? 'الباسوورد لازم يكون 8 حروف على الأقل'
            : 'Password must be at least 8 characters',
      ));
    }

    return _repository.updatePassword(newPassword: newPassword);
  }
}
