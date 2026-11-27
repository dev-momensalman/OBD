import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? phone;
  final String role;
  final String? photoUrl;
  final String? token;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.phone,
    this.role = 'Customer',
    this.photoUrl,
    this.token,
  });

  @override
  List<Object?> get props => [id, email, displayName, phone, role, photoUrl, token];
}
