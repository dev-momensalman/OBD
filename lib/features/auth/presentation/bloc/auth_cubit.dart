import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  AuthCubit({
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  })  : _signInWithEmailUseCase = signInWithEmailUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        super(const AuthInitial());

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool agreedToTerms,
  }) async {
    if (!agreedToTerms) {
      emit(const AuthError('You must agree to the User Agreement & Privacy Policy'));
      return;
    }

    emit(const AuthLoading(message: 'Signing in...'));

    final result = await _signInWithEmailUseCase(
      email: email,
      password: password,
    );

    result.when(
      success: (user) => emit(Authenticated(user)),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> signInWithGoogle({required bool agreedToTerms}) async {
    if (!agreedToTerms) {
      emit(const AuthError('You must agree to the User Agreement & Privacy Policy'));
      return;
    }

    emit(const AuthLoading(message: 'Connecting to Google...'));

    final result = await _signInWithGoogleUseCase();

    result.when(
      success: (user) => emit(Authenticated(user)),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  void resetError() {
    if (state is AuthError) {
      emit(const Unauthenticated());
    }
  }
}
