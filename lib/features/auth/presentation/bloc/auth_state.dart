import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  final String? message;
  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

final class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthConfirmationRequired extends AuthState {
  final String email;
  const AuthConfirmationRequired(this.email);

  @override
  List<Object?> get props => [email];
}

final class AuthOtpResent extends AuthState {
  final String email;
  const AuthOtpResent(this.email);

  @override
  List<Object?> get props => [email];
}

final class AuthOAuthPending extends AuthState {
  final String message;
  const AuthOAuthPending(this.message);

  @override
  List<Object?> get props => [message];
}

final class AuthResetLinkSent extends AuthState {
  final String email;
  const AuthResetLinkSent(this.email);

  @override
  List<Object?> get props => [email];
}

final class AuthPasswordUpdated extends AuthState {
  final UserEntity user;
  const AuthPasswordUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
