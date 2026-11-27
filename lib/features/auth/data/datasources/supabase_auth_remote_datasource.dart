import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:obd_vision/core/config/app_env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/auth_session_event.dart';
import '../models/user_model.dart';
import 'auth_error_translator.dart';
import 'auth_remote_datasource.dart';

/// Real Supabase Auth implementation following `AUTH_API.md` and
/// `supabase-flutter-auth-setup` guidelines.
class SupabaseAuthRemoteDataSource implements IAuthRemoteDataSource {
  final SupabaseClient _client;

  SupabaseAuthRemoteDataSource(this._client);

  @override
  UserModel? get currentUser {
    final session = _client.auth.currentSession;
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return _mapUser(user, accessToken: session?.accessToken);
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
    final user = response.user;
    if (user == null) {
      throw const LocalizedAuthException(
        en: 'Invalid email or password.',
        ar: 'بيانات الدخول غير صحيحة',
      );
    }
    return _mapUser(user, accessToken: response.session?.accessToken);
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final cleanPhone = phone?.trim();
    final response = await _client.auth.signUp(
      email: email.trim().toLowerCase(),
      password: password,
      emailRedirectTo: kIsWeb ? null : AppEnv.resetPasswordRedirectUrl,
      data: {
        'full_name': fullName.trim(),
        if (cleanPhone != null && cleanPhone.isNotEmpty) 'phone': cleanPhone,
        'role': 'Customer', // Enforced: never ship Admin from mobile
      },
    );

    final user = response.user;
    if (user == null) {
      throw const LocalizedAuthException(
        en: 'Could not create account. Please try again.',
        ar: 'تعذر إنشاء الحساب، جرّب تاني',
      );
    }
    return _mapUser(user, accessToken: response.session?.accessToken);
  }

  @override
  Future<UserModel> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    final response = await _client.auth.verifyOTP(
      email: email.trim().toLowerCase(),
      token: token.trim(),
      type: OtpType.signup,
    );
    final user = response.user ?? _client.auth.currentUser;
    final session = response.session ?? _client.auth.currentSession;
    if (user == null || session == null) {
      throw const LocalizedAuthException(
        en: 'Invalid or expired verification code.',
        ar: 'رمز التحقق غير صحيح أو منتهي الصلاحية.',
      );
    }
    return _mapUser(user, accessToken: session.accessToken);
  }

  @override
  Future<void> resendSignUpOtp({required String email}) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email.trim().toLowerCase(),
      emailRedirectTo: kIsWeb ? null : AppEnv.loginCallbackUrl,
    );
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : AppEnv.loginCallbackUrl,
    );
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const OAuthPendingException();
    }
    return _mapUser(user, accessToken: _client.auth.currentSession?.accessToken);
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    throw const LocalizedAuthException(
      en: 'Facebook sign-in is coming soon.',
      ar: 'تسجيل الدخول عبر فيسبوك غير متاح حالياً.',
    );
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    final normalizedEmail = email.trim().toLowerCase();

    final exists = await _client.rpc(
      'email_is_registered',
      params: {'check_email': normalizedEmail},
    ) as bool;

    if (!exists) {
      throw const LocalizedAuthException(
        en: 'This email is not registered.',
        ar: 'الإيميل ده مش مسجّل عندنا',
      );
    }

    await _client.auth.resetPasswordForEmail(
      normalizedEmail,
      redirectTo: kIsWeb ? null : AppEnv.resetPasswordRedirectUrl,
    );
  }

  @override
  Future<UserModel> updatePassword({required String newPassword}) async {
    final response = await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    final user = response.user;
    if (user == null) {
      throw const LocalizedAuthException(
        en: 'Could not update password. Please request a new reset link.',
        ar: 'تعذر تحديث كلمة المرور، اطلب رابط استعادة جديد.',
      );
    }
    return _mapUser(user, accessToken: _client.auth.currentSession?.accessToken);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<UserModel?> get authStateChanges => _client.auth.onAuthStateChange.map(
        (authState) {
          final user = authState.session?.user;
          if (user == null) return null;
          return _mapUser(user, accessToken: authState.session?.accessToken);
        },
      );

  @override
  Stream<AuthSessionEvent> get sessionEvents =>
      _client.auth.onAuthStateChange.transform(
        StreamTransformer<AuthState, AuthSessionEvent>.fromHandlers(
          handleData: (authState, sink) {
            final user = authState.session?.user;
            final mappedUser = user != null
                ? _mapUser(user, accessToken: authState.session?.accessToken)
                : null;

            switch (authState.event) {
              case AuthChangeEvent.initialSession:
                sink.add(AuthSessionEvent(
                  kind: mappedUser != null
                      ? AuthSessionKind.initialSignedIn
                      : AuthSessionKind.signedOut,
                  user: mappedUser,
                ));
              case AuthChangeEvent.signedIn:
                sink.add(AuthSessionEvent(
                  kind: AuthSessionKind.signedIn,
                  user: mappedUser,
                ));
              case AuthChangeEvent.passwordRecovery:
                sink.add(AuthSessionEvent(
                  kind: AuthSessionKind.passwordRecovery,
                  user: mappedUser,
                ));
              case AuthChangeEvent.signedOut:
                sink.add(const AuthSessionEvent(
                  kind: AuthSessionKind.signedOut,
                ));
              default:
                break;
            }
          },
          handleError: (error, stackTrace, sink) {
            sink.add(AuthSessionEvent(
              kind: AuthSessionKind.error,
              errorMessage: error.toString(),
            ));
          },
        ),
      );

  UserModel _mapUser(User user, {String? accessToken}) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: metadata['full_name'] as String? ??
          metadata['name'] as String? ??
          user.email?.split('@').first,
      phone: metadata['phone'] as String? ?? user.phone,
      role: metadata['role'] as String? ?? 'Customer',
      photoUrl: metadata['avatar_url'] as String?,
      token: accessToken,
    );
  }
}
