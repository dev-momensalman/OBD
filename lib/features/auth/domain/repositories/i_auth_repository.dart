import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<Result<UserEntity, Failure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<UserEntity, Failure>> signInWithGoogle();

  Future<Result<UserEntity, Failure>> signInWithFacebook();

  Future<Result<void, Failure>> signOut();

  Stream<UserEntity?> get authStateChanges;
}
