import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../repositories/i_auth_repository.dart';

class RequestPasswordResetUseCase {
  final IAuthRepository _repository;

  const RequestPasswordResetUseCase(this._repository);

  Future<Result<void, Failure>> call({
    required String email,
    bool isArabic = false,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    final emailRegex = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$');
    if (trimmedEmail.isEmpty || !emailRegex.hasMatch(trimmedEmail)) {
      return Err(AuthFailure(
        isArabic
            ? 'من فضلك أدخل بريداً إلكترونياً صحيحاً'
            : 'Please enter a valid email address',
      ));
    }

    return _repository.requestPasswordReset(email: trimmedEmail);
  }
}
