import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.username,
    required super.email,
    required super.displayName,
    super.avatarUrl,
    required super.vehicleName,
    required super.deviceSerial,
    super.preferredLanguage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? 'youssefgad_26',
      email: json['email'] as String? ?? 'youssef@example.com',
      displayName: json['display_name'] as String? ?? json['displayName'] as String? ?? 'Youssef Gad',
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      vehicleName: json['vehicle_name'] as String? ?? json['vehicleName'] as String? ?? 'Corolla 2018',
      deviceSerial: json['device_serial'] as String? ?? json['deviceSerial'] as String? ?? 'OBD-II v2.4',
      preferredLanguage: json['preferred_language'] as String? ?? 'English',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'vehicle_name': vehicleName,
      'device_serial': deviceSerial,
      'preferred_language': preferredLanguage,
    };
  }

  UserProfileEntity toEntity() => this;
}
