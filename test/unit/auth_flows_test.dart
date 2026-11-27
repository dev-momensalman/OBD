import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/core/utils/result.dart';
import 'package:obd_vision/features/auth/data/datasources/auth_error_translator.dart';
import 'package:obd_vision/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:obd_vision/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:obd_vision/features/auth/domain/entities/user_entity.dart';
import 'package:obd_vision/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:obd_vision/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:obd_vision/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:obd_vision/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:obd_vision/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockSignInWithEmailUseCase extends Mock
    implements SignInWithEmailUseCase {}

class MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

void main() {
  late MockAuthRepository mockRepo;
  late SignUpWithEmailUseCase signUpUseCase;
  late RequestPasswordResetUseCase resetUseCase;
  late UpdatePasswordUseCase updatePasswordUseCase;
  late MockSignInWithEmailUseCase mockSignInEmail;
  late MockSignInWithGoogleUseCase mockSignInGoogle;

  const sampleUserWithToken = UserEntity(
    id: 'usr-1',
    email: 'driver@obd.app',
    displayName: 'Momen Salman',
    role: 'Customer',
    token: 'session-active',
  );

  const sampleUserNeedsConfirmation = UserEntity(
    id: 'usr-1',
    email: 'driver@obd.app',
    displayName: 'Momen Salman',
    role: 'Customer',
  );

  setUp(() {
    mockRepo = MockAuthRepository();
    signUpUseCase = SignUpWithEmailUseCase(mockRepo);
    resetUseCase = RequestPasswordResetUseCase(mockRepo);
    updatePasswordUseCase = UpdatePasswordUseCase(mockRepo);
    mockSignInEmail = MockSignInWithEmailUseCase();
    mockSignInGoogle = MockSignInWithGoogleUseCase();
  });

  group('Auth UseCases validation & delegation', () {
    test('SignUpWithEmailUseCase rejects <8 char password before repo call', () async {
      final result = await signUpUseCase(
        fullName: 'Momen Salman',
        email: 'driver@obd.app',
        password: '123',
        isArabic: true,
      );

      expect(result, isA<Err<UserEntity, Failure>>());
      expect(
        (result as Err<UserEntity, Failure>).error.message,
        contains('8'),
      );
      verifyNever(() => mockRepo.signUpWithEmail(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    test('RequestPasswordResetUseCase trims & lowercases email', () async {
      when(() => mockRepo.requestPasswordReset(email: 'driver@obd.app'))
          .thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await resetUseCase(email: '  Driver@OBD.app  ');
      expect(result, isA<Success<void, Failure>>());
      verify(() => mockRepo.requestPasswordReset(email: 'driver@obd.app'))
          .called(1);
    });

    test('UpdatePasswordUseCase rejects <8 char password', () async {
      final result = await updatePasswordUseCase(newPassword: 'short');
      expect(result, isA<Err<UserEntity, Failure>>());
      verifyNever(
          () => mockRepo.updatePassword(newPassword: any(named: 'newPassword')));
    });
  });

  group('AuthCubit extended flows', () {
    AuthCubit buildCubit({bool arabic = false}) => AuthCubit(
          signInWithEmailUseCase: mockSignInEmail,
          signInWithGoogleUseCase: mockSignInGoogle,
          signUpWithEmailUseCase: signUpUseCase,
          requestPasswordResetUseCase: resetUseCase,
          updatePasswordUseCase: updatePasswordUseCase,
          authRepository: mockRepo,
          isArabic: () => arabic,
        );

    blocTest<AuthCubit, AuthState>(
      'signUpWithEmail emits Authenticated when session token is issued',
      build: () {
        when(() => mockRepo.signUpWithEmail(
              fullName: 'Momen Salman',
              email: 'driver@obd.app',
              password: 'Password123',
              phone: '+201000000000',
            )).thenAnswer((_) async => const Success(sampleUserWithToken));
        return buildCubit();
      },
      act: (cubit) => cubit.signUpWithEmail(
        fullName: 'Momen Salman',
        email: 'driver@obd.app',
        password: 'Password123',
        confirmPassword: 'Password123',
        agreedToTerms: true,
        phone: '+201000000000',
      ),
      expect: () => const [
        AuthLoading(message: 'Creating account...'),
        Authenticated(sampleUserWithToken),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'signUpWithEmail emits AuthConfirmationRequired when email confirmation is needed',
      build: () {
        when(() => mockRepo.signUpWithEmail(
              fullName: 'Momen Salman',
              email: 'driver@obd.app',
              password: 'Password123',
              phone: null,
            )).thenAnswer(
          (_) async => const Success(sampleUserNeedsConfirmation),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.signUpWithEmail(
        fullName: 'Momen Salman',
        email: 'driver@obd.app',
        password: 'Password123',
        confirmPassword: 'Password123',
        agreedToTerms: true,
      ),
      expect: () => const [
        AuthLoading(message: 'Creating account...'),
        AuthConfirmationRequired('driver@obd.app'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'requestPasswordReset emits AuthResetLinkSent on success',
      build: () {
        when(() => mockRepo.requestPasswordReset(email: 'driver@obd.app'))
            .thenAnswer((_) async => const Success<void, Failure>(null));
        return buildCubit();
      },
      act: (cubit) => cubit.requestPasswordReset(email: 'driver@obd.app'),
      expect: () => const [
        AuthLoading(message: 'Sending reset link...'),
        AuthResetLinkSent('driver@obd.app'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'updatePassword emits AuthPasswordUpdated when passwords match',
      build: () {
        when(() => mockRepo.updatePassword(newPassword: 'NewPassword123'))
            .thenAnswer((_) async => const Success(sampleUserWithToken));
        return buildCubit();
      },
      act: (cubit) => cubit.updatePassword(
        newPassword: 'NewPassword123',
        confirmPassword: 'NewPassword123',
      ),
      expect: () => const [
        AuthLoading(message: 'Updating password...'),
        AuthPasswordUpdated(sampleUserWithToken),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'verifyEmailOtp emits Authenticated when OTP succeeds',
      build: () {
        when(() => mockRepo.verifyEmailOtp(
              email: 'driver@obd.app',
              token: '123456',
            )).thenAnswer((_) async => const Success(sampleUserWithToken));
        return buildCubit();
      },
      act: (cubit) => cubit.verifyEmailOtp(
        email: 'driver@obd.app',
        token: '123456',
      ),
      expect: () => const [
        AuthLoading(message: 'Verifying code...'),
        Authenticated(sampleUserWithToken),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'signInWithGoogle emits AuthOAuthPending when browser handoff returns pending code',
      build: () {
        when(() => mockSignInGoogle()).thenAnswer(
          (_) async => const Err(
            AuthFailure(
              'Complete sign-in in your browser',
              code: 'oauth_pending',
            ),
          ),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.signInWithGoogle(agreedToTerms: true),
      expect: () => const [
        AuthLoading(message: 'Connecting to Google...'),
        AuthOAuthPending('Complete sign-in in your browser'),
      ],
    );
  });

  group('AuthRepositoryImpl session persistence & validation', () {
    test('caches signed-in user across repository restarts and clears on signOut', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = AppPreferences(sp);

      final ds1 = MockAuthRemoteDataSource();
      final repo1 = AuthRepositoryImpl(ds1, preferences: prefs);

      final signInRes = await repo1.signInWithEmailAndPassword(
        email: 'driver@obd.cloud',
        password: 'Password123',
      );
      expect(signInRes.isSuccess, isTrue);
      expect(repo1.currentUser?.email, 'driver@obd.cloud');
      repo1.dispose();

      // Simulate cold restart with fresh in-memory datasource + same SharedPreferences
      final ds2 = MockAuthRemoteDataSource();
      final repo2 = AuthRepositoryImpl(ds2, preferences: prefs);
      expect(repo2.currentUser, isNotNull);
      expect(repo2.currentUser!.email, 'driver@obd.cloud');

      await repo2.signOut();
      expect(repo2.currentUser, isNull);
      repo2.dispose();
    });

    test('verifyEmailOtp stores verified session cleanly', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = AppPreferences(sp);
      final ds = MockAuthRemoteDataSource();
      final repo = AuthRepositoryImpl(ds, preferences: prefs);

      final res = await repo.verifyEmailOtp(
        email: 'verified@obd.cloud',
        token: '654321',
      );
      expect(res.isSuccess, isTrue);
      expect(repo.currentUser?.email, 'verified@obd.cloud');
      expect(repo.currentUser?.token, isNotNull);
      repo.dispose();
    });

    test('SignInWithEmailUseCase accepts long TLDs and localizes Arabic errors', () async {
      final useCase = SignInWithEmailUseCase(mockRepo);
      when(() => mockRepo.signInWithEmailAndPassword(
            email: 'driver@obd.cloud',
            password: 'Password123',
          )).thenAnswer((_) async => const Success(sampleUserWithToken));

      final valid = await useCase(
        email: 'driver@obd.cloud',
        password: 'Password123',
      );
      expect(valid.isSuccess, isTrue);

      final emptyAr = await useCase(email: '', password: '123', isArabic: true);
      expect(emptyAr.isError, isTrue);
      expect(emptyAr.errorOrNull?.message, contains('البريد'));

      expect(
        const OAuthPendingException().messageFor(isArabic: true),
        contains('المتصفح'),
      );
    });
  });
}
