import 'dart:async';
import '../../domain/entities/auth_session_event.dart';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });

  Future<UserModel> verifyEmailOtp({
    required String email,
    required String token,
  });

  Future<void> resendSignUpOtp({required String email});

  Future<UserModel> signInWithGoogle();

  Future<UserModel> signInWithFacebook();

  Future<void> requestPasswordReset({required String email});

  Future<UserModel> updatePassword({required String newPassword});

  Future<void> signOut();

  UserModel? get currentUser;

  Stream<UserModel?> get authStateChanges;

  Stream<AuthSessionEvent> get sessionEvents;
}

class MockAuthRemoteDataSource implements IAuthRemoteDataSource {
  final _controller = StreamController<UserModel?>.broadcast();
  final _sessionController = StreamController<AuthSessionEvent>.broadcast();
  UserModel? _currentUser;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (password == 'wrongpassword') {
      throw Exception('Invalid login credentials');
    }

    _currentUser = UserModel(
      id: 'usr_mock_123',
      email: email.trim().toLowerCase(),
      displayName: email.split('@').first,
      token: 'jwt_mock_token_abc',
    );
    _controller.add(_currentUser);
    _sessionController.add(AuthSessionEvent(
      kind: AuthSessionKind.signedIn,
      user: _currentUser,
    ));
    return _currentUser!;
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    _currentUser = UserModel(
      id: 'usr_mock_signup_123',
      email: email.trim().toLowerCase(),
      displayName: fullName.trim(),
      phone: phone?.trim(),
      role: 'Customer',
      token: 'jwt_mock_signup_token',
    );
    _controller.add(_currentUser);
    _sessionController.add(AuthSessionEvent(
      kind: AuthSessionKind.signedIn,
      user: _currentUser,
    ));
    return _currentUser!;
  }

  @override
  Future<UserModel> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final clean = token.trim();
    if (clean.length < 4 || clean == '0000' || clean == '000000') {
      throw Exception('Invalid verification code');
    }
    _currentUser = UserModel(
      id: 'usr_mock_verified',
      email: email.trim().toLowerCase(),
      displayName: email.trim().split('@').first,
      role: 'Customer',
      token: 'jwt_mock_verified_token',
    );
    _controller.add(_currentUser);
    _sessionController.add(AuthSessionEvent(
      kind: AuthSessionKind.signedIn,
      user: _currentUser,
    ));
    return _currentUser!;
  }

  @override
  Future<void> resendSignUpOtp({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = const UserModel(
      id: 'usr_google_456',
      email: 'alex.driver@gmail.com',
      displayName: 'Alex Driver',
      photoUrl: 'https://lh3.googleusercontent.com/mock',
      token: 'jwt_google_token_xyz',
    );
    _controller.add(_currentUser);
    _sessionController.add(AuthSessionEvent(
      kind: AuthSessionKind.signedIn,
      user: _currentUser,
    ));
    return _currentUser!;
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = const UserModel(
      id: 'usr_fb_789',
      email: 'alex.fb@facebook.com',
      displayName: 'Alex Driver',
      token: 'jwt_fb_token_xyz',
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<UserModel> updatePassword({required String newPassword}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser ??= const UserModel(
      id: 'usr_mock_123',
      email: 'user@example.com',
      token: 'jwt_mock_updated',
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
    _sessionController.add(const AuthSessionEvent(
      kind: AuthSessionKind.signedOut,
    ));
  }

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Stream<AuthSessionEvent> get sessionEvents => _sessionController.stream;

  void dispose() {
    _controller.close();
    _sessionController.close();
  }
}
