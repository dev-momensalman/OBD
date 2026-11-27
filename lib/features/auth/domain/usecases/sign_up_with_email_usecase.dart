import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class SignUpWithEmailUseCase {
  final IAuthRepository _repository;

  const SignUpWithEmailUseCase(this._repository);

  Future<Result<UserEntity, Failure>> call({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    bool isArabic = false,
  }) async {
    final trimmedName = fullName.trim();
    if (trimmedName.isEmpty) {
      return Err(AuthFailure(
        isArabic ? 'من فضلك أدخل اسمك الكامل' : 'Please enter your full name',
      ));
    }

    final trimmedEmail = email.trim().toLowerCase();
    final emailRegex = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$');
    if (trimmedEmail.isEmpty || !emailRegex.hasMatch(trimmedEmail)) {
      return Err(AuthFailure(
        isArabic
            ? 'من فضلك أدخل بريداً إلكترونياً صحيحاً'
            : 'Please enter a valid email address',
      ));
    }

    if (password.length < 8) {
      return Err(AuthFailure(
        isArabic
            ? 'الباسوورد لازم يكون 8 حروف على الأقل'
            : 'Password must be at least 8 characters',
      ));
    }

    return _repository.signUpWithEmail(
      fullName: trimmedName,
      email: trimmedEmail,
      password: password,
      phone: phone?.trim(),
    );
  }
}
