import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../entities/auth_session_event.dart';
import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<Result<UserEntity, Failure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<UserEntity, Failure>> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });

  Future<Result<UserEntity, Failure>> verifyEmailOtp({
    required String email,
    required String token,
  });

  Future<Result<void, Failure>> resendSignUpOtp({required String email});

  Future<Result<UserEntity, Failure>> signInWithGoogle();

  Future<Result<UserEntity, Failure>> signInWithFacebook();

  Future<Result<void, Failure>> requestPasswordReset({required String email});

  Future<Result<UserEntity, Failure>> updatePassword({
    required String newPassword,
  });

  Future<Result<void, Failure>> signOut();

  UserEntity? get currentUser;

  Stream<UserEntity?> get authStateChanges;

  Stream<AuthSessionEvent> get sessionEvents;
}
