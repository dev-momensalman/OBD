import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import 'package:obd_vision/features/auth/domain/entities/auth_session_event.dart';
import 'package:obd_vision/features/auth/domain/entities/user_entity.dart';
import 'package:obd_vision/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_email_usecase.dart';

class MockAuthRepo implements IAuthRepository {
  bool shouldSucceed = true;

  @override
  UserEntity? get currentUser => null;

  @override
  Future<Result<UserEntity, Failure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldSucceed) {
      return Success(UserEntity(id: '123', email: email));
    } else {
      return const Err(AuthFailure('Invalid credentials'));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    if (shouldSucceed) {
      return Success(UserEntity(
        id: '123',
        email: email,
        displayName: fullName,
        phone: phone,
        token: 'mock_token',
      ));
    }
    return const Err(AuthFailure('Sign up failed'));
  }

  @override
  Future<Result<UserEntity, Failure>> verifyEmailOtp({
    required String email,
    required String token,
  }) async =>
      Success(UserEntity(id: '123', email: email, token: 'mock_otp_token'));

  @override
  Future<Result<void, Failure>> resendSignUpOtp({required String email}) async =>
      const Success(null);

  @override
  Future<Result<UserEntity, Failure>> signInWithGoogle() async =>
      const Success(UserEntity(id: '456', email: 'g@test.com'));

  @override
  Future<Result<UserEntity, Failure>> signInWithFacebook() async =>
      const Success(UserEntity(id: '789', email: 'fb@test.com'));

  @override
  Future<Result<void, Failure>> requestPasswordReset({required String email}) async =>
      shouldSucceed ? const Success(null) : const Err(AuthFailure('Email not registered'));

  @override
  Future<Result<UserEntity, Failure>> updatePassword({required String newPassword}) async =>
      const Success(UserEntity(id: '123', email: 'test@example.com'));

  @override
  Future<Result<void, Failure>> signOut() async => const Success(null);

  @override
  Stream<UserEntity?> get authStateChanges => Stream.value(null);

  @override
  Stream<AuthSessionEvent> get sessionEvents => const Stream.empty();
}

void main() {
  late MockAuthRepo mockRepo;
  late SignInWithEmailUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepo();
    useCase = SignInWithEmailUseCase(mockRepo);
  });

  group('SignInWithEmailUseCase Business Validation', () {
    test('returns AuthFailure when email is empty', () async {
      final result = await useCase(email: '', password: 'password123');
      expect(result.isError, isTrue);
      expect(result.errorOrNull, isA<AuthFailure>());
      expect(result.errorOrNull?.message, 'Please enter your email address');
    });

    test('returns AuthFailure when email format is invalid', () async {
      final result = await useCase(email: 'invalid-email', password: 'password123');
      expect(result.isError, isTrue);
      expect(result.errorOrNull?.message, 'Please enter a valid email address');
    });

    test('returns AuthFailure when password is empty', () async {
      final result = await useCase(email: 'test@example.com', password: '');
      expect(result.isError, isTrue);
      expect(result.errorOrNull?.message, 'Please enter your password');
    });

    test('returns AuthFailure when password is shorter than 6 characters', () async {
      final result = await useCase(email: 'test@example.com', password: '123');
      expect(result.isError, isTrue);
      expect(result.errorOrNull?.message, 'Password must be at least 6 characters');
    });

    test('returns Success with UserEntity when input is valid', () async {
      final result = await useCase(email: 'test@example.com', password: 'password123');
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.email, 'test@example.com');
      expect(result.dataOrNull?.id, '123');
    });

    test('returns Err when repository returns failure', () async {
      mockRepo.shouldSucceed = false;
      final result = await useCase(email: 'test@example.com', password: 'password123');
      expect(result.isError, isTrue);
      expect(result.errorOrNull?.message, 'Invalid credentials');
    });
  });
}
