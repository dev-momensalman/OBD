import 'dart:async';
import 'dart:convert';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/core/utils/result.dart';
import '../../domain/entities/auth_session_event.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_error_translator.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final AppPreferences? _preferences;
  final bool Function() _isArabic;
  StreamSubscription<AuthSessionEvent>? _sessionSub;

  AuthRepositoryImpl(
    this._remoteDataSource, {
    AppPreferences? preferences,
    bool Function()? isArabic,
  })  : _preferences = preferences,
        _isArabic = isArabic ?? (() => false) {
    if (_preferences != null) {
      _sessionSub = _remoteDataSource.sessionEvents.listen((event) {
        if ((event.kind == AuthSessionKind.signedIn ||
                event.kind == AuthSessionKind.initialSignedIn) &&
            event.user != null) {
          _persistUser(event.user!);
        } else if (event.kind == AuthSessionKind.signedOut) {
          _preferences.setCachedAuthUserJson(null);
        }
      });
    }
  }

  @override
  UserEntity? get currentUser {
    final live = _remoteDataSource.currentUser?.toEntity();
    if (live != null) return live;
    return _readCachedUser();
  }

  UserEntity? _readCachedUser() {
    final raw = _preferences?.cachedAuthUserJson;
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final model = UserModel.fromJson(map);
      if (model.id.isEmpty && model.email.isEmpty) return null;
      return model.toEntity();
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistUser(UserEntity user) async {
    if (_preferences == null) return;
    final model = UserModel.fromEntity(user);
    await _preferences.setGuestSession(false);
    await _preferences.setCachedAuthUserJson(jsonEncode(model.toJson()));
  }

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
      final entity = model.toEntity();
      await _persistUser(entity);
      return Success(entity);
    } catch (e) {
      return Err(_mapFailure(e));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final model = await _remoteDataSource.signUpWithEmail(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );
      final entity = model.toEntity();
      if (entity.token != null) {
        await _persistUser(entity);
      }
      return Success(entity);
    } catch (e) {
      return Err(_mapFailure(e));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    try {
      final model = await _remoteDataSource.verifyEmailOtp(
        email: email,
        token: token,
      );
      final entity = model.toEntity();
      await _persistUser(entity);
      return Success(entity);
    } catch (e) {
      return Err(_mapFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> resendSignUpOtp({required String email}) async {
    try {
      await _remoteDataSource.resendSignUpOtp(email: email);
      return const Success(null);
    } catch (e) {
      return Err(_mapFailure(e));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> signInWithGoogle() async {
    try {
      final model = await _remoteDataSource.signInWithGoogle();
      final entity = model.toEntity();
      await _persistUser(entity);
      return Success(entity);
    } catch (e) {
      return Err(_mapFailure(e));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> signInWithFacebook() async {
    try {
      final model = await _remoteDataSource.signInWithFacebook();
      final entity = model.toEntity();
      await _persistUser(entity);
      return Success(entity);
    } catch (e) {
      return Err(_mapFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> requestPasswordReset({
    required String email,
  }) async {
    try {
      await _remoteDataSource.requestPasswordReset(email: email);
      return const Success(null);
    } catch (e) {
      return Err(_mapFailure(e));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> updatePassword({
    required String newPassword,
  }) async {
    try {
      final model =
          await _remoteDataSource.updatePassword(newPassword: newPassword);
      final entity = model.toEntity();
      await _persistUser(entity);
      return Success(entity);
    } catch (e) {
      return Err(_mapFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      await _preferences?.setCachedAuthUserJson(null);
      await _preferences?.setGuestSession(false);
      return const Success(null);
    } catch (e) {
      await _preferences?.setCachedAuthUserJson(null);
      return Err(_mapFailure(e));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges.map((m) => m?.toEntity());

  @override
  Stream<AuthSessionEvent> get sessionEvents => _remoteDataSource.sessionEvents;

  Failure _mapFailure(Object error) {
    final arabic = _isArabic();
    if (error is OAuthPendingException) {
      return AuthFailure(
        error.messageFor(isArabic: arabic),
        code: 'oauth_pending',
      );
    }
    if (error is LocalizedAuthException) {
      return AuthFailure(error.messageFor(isArabic: arabic));
    }
    return AuthFailure(
      translateAuthErrorMessage(error.toString(), isArabic: arabic),
    );
  }

  void dispose() {
    _sessionSub?.cancel();
  }
}
