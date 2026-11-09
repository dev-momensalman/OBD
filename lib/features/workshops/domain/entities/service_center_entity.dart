class ServiceCenterEntity {
  final String id;
  final String name;
  final String distance;
  final double rating;
  final int reviewsCount;
  final String workingHours;
  final bool isOpen;
  final List<String> tags;
  final String? address;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;

  const ServiceCenterEntity({
    required this.id,
    required this.name,
    required this.distance,
    required this.rating,
    required this.reviewsCount,
    required this.workingHours,
    required this.isOpen,
    required this.tags,
    this.address,
    this.phoneNumber,
    this.latitude,
    this.longitude,
  });
}
