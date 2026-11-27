import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/request_password_reset_usecase.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignUpWithEmailUseCase? _signUpWithEmailUseCase;
  final RequestPasswordResetUseCase? _requestPasswordResetUseCase;
  final UpdatePasswordUseCase? _updatePasswordUseCase;
  final IAuthRepository? _authRepository;
  final bool Function() _isArabic;

  AuthCubit({
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    SignUpWithEmailUseCase? signUpWithEmailUseCase,
    RequestPasswordResetUseCase? requestPasswordResetUseCase,
    UpdatePasswordUseCase? updatePasswordUseCase,
    IAuthRepository? authRepository,
    bool Function()? isArabic,
  })  : _signInWithEmailUseCase = signInWithEmailUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signUpWithEmailUseCase = signUpWithEmailUseCase,
        _requestPasswordResetUseCase = requestPasswordResetUseCase,
        _updatePasswordUseCase = updatePasswordUseCase,
        _authRepository = authRepository,
        _isArabic = isArabic ?? (() => false),
        super(const AuthInitial());

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool agreedToTerms,
  }) async {
    final arabic = _isArabic();
    if (!agreedToTerms) {
      emit(AuthError(
        arabic
            ? 'يجب الموافقة على اتفاقية المستخدم وسياسة الخصوصية'
            : 'You must agree to the User Agreement & Privacy Policy',
      ));
      return;
    }

    emit(AuthLoading(message: arabic ? 'جاري تسجيل الدخول...' : 'Signing in...'));

    final result = await _signInWithEmailUseCase(
      email: email,
      password: password,
      isArabic: arabic,
    );

    _emitAuthResult(result);
  }

  void _emitAuthResult(dynamic result) {
    result.when(
      success: (user) => emit(Authenticated(user)),
      error: (failure) {
        if (failure.code == 'oauth_pending') {
          emit(AuthOAuthPending(failure.message));
        } else {
          emit(AuthError(failure.message));
        }
      },
    );
  }

  Future<void> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool agreedToTerms,
    String? phone,
  }) async {
    final arabic = _isArabic();
    if (!agreedToTerms) {
      emit(AuthError(
        arabic
            ? 'يجب الموافقة على اتفاقية المستخدم وسياسة الخصوصية'
            : 'You must agree to the User Agreement & Privacy Policy',
      ));
      return;
    }
    if (password != confirmPassword) {
      emit(AuthError(
        arabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match',
      ));
      return;
    }
    if (_signUpWithEmailUseCase == null) {
      emit(AuthError(
        arabic ? 'خدمة التسجيل غير متاحة الآن' : 'Sign-up service is unavailable.',
      ));
      return;
    }

    emit(AuthLoading(
      message: arabic ? 'جاري إنشاء الحساب...' : 'Creating account...',
    ));

    final result = await _signUpWithEmailUseCase(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      isArabic: arabic,
    );

    result.when(
      success: (user) {
        if (user.token == null) {
          emit(AuthConfirmationRequired(user.email));
        } else {
          emit(Authenticated(user));
        }
      },
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> signInWithGoogle({required bool agreedToTerms}) async {
    final arabic = _isArabic();
    if (!agreedToTerms) {
      emit(AuthError(
        arabic
            ? 'يجب الموافقة على اتفاقية المستخدم وسياسة الخصوصية'
            : 'You must agree to the User Agreement & Privacy Policy',
      ));
      return;
    }

    emit(AuthLoading(
      message: arabic ? 'جاري الاتصال بـ Google...' : 'Connecting to Google...',
    ));

    final result = await _signInWithGoogleUseCase();
    _emitAuthResult(result);
  }

  Future<void> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    final arabic = _isArabic();
    if (_authRepository == null) {
      emit(AuthError(
        arabic ? 'خدمة التحقق غير متاحة الآن' : 'Verification service unavailable.',
      ));
      return;
    }

    emit(AuthLoading(
      message: arabic ? 'جاري التحقق من الرمز...' : 'Verifying code...',
    ));

    final result = await _authRepository.verifyEmailOtp(
      email: email,
      token: token,
    );

    result.when(
      success: (user) => emit(Authenticated(user)),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> resendSignUpOtp({required String email}) async {
    final arabic = _isArabic();
    if (_authRepository == null) {
      emit(AuthError(
        arabic ? 'تعذر إعادة الإرسال' : 'Could not resend verification code.',
      ));
      return;
    }

    final result = await _authRepository.resendSignUpOtp(email: email);
    result.when(
      success: (_) => emit(AuthOtpResent(email)),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> requestPasswordReset({required String email}) async {
    final arabic = _isArabic();
    if (_requestPasswordResetUseCase == null) {
      emit(AuthError(
        arabic
            ? 'خدمة استعادة كلمة المرور غير متاحة الآن'
            : 'Password reset service is unavailable.',
      ));
      return;
    }

    emit(AuthLoading(
      message: arabic ? 'جاري إرسال الرابط...' : 'Sending reset link...',
    ));

    final result = await _requestPasswordResetUseCase(
      email: email,
      isArabic: arabic,
    );

    result.when(
      success: (_) => emit(AuthResetLinkSent(email.trim().toLowerCase())),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> updatePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    final arabic = _isArabic();
    if (newPassword != confirmPassword) {
      emit(AuthError(
        arabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match',
      ));
      return;
    }
    if (_updatePasswordUseCase == null) {
      emit(AuthError(
        arabic
            ? 'خدمة تحديث كلمة المرور غير متاحة الآن'
            : 'Password update service is unavailable.',
      ));
      return;
    }

    emit(AuthLoading(
      message: arabic ? 'جاري تحديث كلمة المرور...' : 'Updating password...',
    ));

    final result = await _updatePasswordUseCase(
      newPassword: newPassword,
      isArabic: arabic,
    );

    result.when(
      success: (user) => emit(AuthPasswordUpdated(user)),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> signOut() async {
    if (_authRepository != null) {
      await _authRepository.signOut();
    }
    emit(const Unauthenticated());
  }

  void resetError() {
    if (state is AuthError) {
      emit(const Unauthenticated());
    }
  }
}
