import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class SignInWithGoogleUseCase {
  final IAuthRepository _repository;

  const SignInWithGoogleUseCase(this._repository);

  Future<Result<UserEntity, Failure>> call() {
    return _repository.signInWithGoogle();
  }
}
