import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UserEntity, Failure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(model.toEntity());
    } catch (e) {
      return Err(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> signInWithGoogle() async {
    try {
      final model = await _remoteDataSource.signInWithGoogle();
      return Success(model.toEntity());
    } catch (e) {
      return Err(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> signInWithFacebook() async {
    try {
      final model = await _remoteDataSource.signInWithFacebook();
      return Success(model.toEntity());
    } catch (e) {
      return Err(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Result<void, Failure>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Success(null);
    } catch (e) {
      return Err(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges.map((m) => m?.toEntity());
}
