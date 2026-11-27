import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class SignInWithEmailUseCase {
  final IAuthRepository _repository;

  const SignInWithEmailUseCase(this._repository);

  Future<Result<UserEntity, Failure>> call({
    required String email,
    required String password,
    bool isArabic = false,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    if (trimmedEmail.isEmpty) {
      return Err(AuthFailure(
        isArabic
            ? 'من فضلك أدخل البريد الإلكتروني'
            : 'Please enter your email address',
      ));
    }

    final emailRegex = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return Err(AuthFailure(
        isArabic
            ? 'من فضلك أدخل بريداً إلكترونياً صحيحاً'
            : 'Please enter a valid email address',
      ));
    }

    if (password.isEmpty) {
      return Err(AuthFailure(
        isArabic ? 'من فضلك أدخل كلمة المرور' : 'Please enter your password',
      ));
    }

    if (password.length < 6) {
      return Err(AuthFailure(
        isArabic
            ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
            : 'Password must be at least 6 characters',
      ));
    }

    return _repository.signInWithEmailAndPassword(
      email: trimmedEmail,
      password: password,
    );
  }
}
