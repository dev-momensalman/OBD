import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class BluetoothFailure extends Failure {
  const BluetoothFailure(super.message, {super.code});
}

class ObdProtocolFailure extends Failure {
  const ObdProtocolFailure(super.message, {super.code});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.code});
}

class InsufficientEvidenceFailure extends Failure {
  const InsufficientEvidenceFailure(super.message, {super.code});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}
