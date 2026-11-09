import 'dart:async';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();

  Future<UserModel> signInWithFacebook();

  Future<void> signOut();

  Stream<UserModel?> get authStateChanges;
}

class MockAuthRemoteDataSource implements IAuthRemoteDataSource {
  final _controller = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Simulate real auth network latency
    await Future.delayed(const Duration(milliseconds: 600));

    if (password == 'wrongpassword') {
      throw Exception('Invalid credentials. Please try again.');
    }

    _currentUser = UserModel(
      id: 'usr_mock_123',
      email: email,
      displayName: email.split('@').first,
      token: 'jwt_mock_token_abc',
    );
    _controller.add(_currentUser);
    return _currentUser!;
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
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
