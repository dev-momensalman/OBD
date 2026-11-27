import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.phone,
    super.role = 'Customer',
    super.photoUrl,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ??
          json['full_name'] as String? ??
          json['name'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'Customer',
      photoUrl: json['photoUrl'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phone': phone,
      'role': role,
      'photoUrl': photoUrl,
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      phone: phone,
      role: role,
      photoUrl: photoUrl,
      token: token,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      phone: entity.phone,
      role: entity.role,
      photoUrl: entity.photoUrl,
      token: entity.token,
    );
  }
}
