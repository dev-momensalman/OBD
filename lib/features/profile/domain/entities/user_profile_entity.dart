class UserProfileEntity {
  final String id;
  final String username;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String vehicleName;
  final String deviceSerial;
  final String preferredLanguage;

  const UserProfileEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    required this.vehicleName,
    required this.deviceSerial,
    this.preferredLanguage = 'English',
  });
}
