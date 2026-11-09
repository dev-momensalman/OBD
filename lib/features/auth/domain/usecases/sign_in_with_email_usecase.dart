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
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      return const Err(AuthFailure('Please enter your email address'));
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return const Err(AuthFailure('Please enter a valid email address'));
    }

    if (password.isEmpty) {
      return const Err(AuthFailure('Please enter your password'));
    }

    if (password.length < 6) {
      return const Err(AuthFailure('Password must be at least 6 characters'));
    }

    return _repository.signInWithEmailAndPassword(
      email: trimmedEmail,
      password: password,
    );
  }
}
