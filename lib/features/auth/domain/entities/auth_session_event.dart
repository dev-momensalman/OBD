import 'package:equatable/equatable.dart';
import 'user_entity.dart';

enum AuthSessionKind {
  initialSignedIn,
  signedIn,
  signedOut,
  passwordRecovery,
  error,
}

class AuthSessionEvent extends Equatable {
  final AuthSessionKind kind;
  final UserEntity? user;
  final String? errorMessage;

  const AuthSessionEvent({
    required this.kind,
    this.user,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [kind, user, errorMessage];
}
