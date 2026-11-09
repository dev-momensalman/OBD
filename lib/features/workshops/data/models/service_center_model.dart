import '../../domain/entities/service_center_entity.dart';

class ServiceCenterModel extends ServiceCenterEntity {
  const ServiceCenterModel({
    required super.id,
    required super.name,
    required super.distance,
    required super.rating,
    required super.reviewsCount,
    required super.workingHours,
    required super.isOpen,
    required super.tags,
    super.address,
    super.phoneNumber,
    super.latitude,
    super.longitude,
  });

  factory ServiceCenterModel.fromJson(Map<String, dynamic> json) {
    return ServiceCenterModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? json['reviewsCount'] as int? ?? 0,
      workingHours: json['working_hours'] as String? ?? json['workingHours'] as String? ?? '',
      isOpen: json['is_open'] as bool? ?? json['isOpen'] as bool? ?? true,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String? ?? json['phoneNumber'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'distance': distance,
      'rating': rating,
      'reviews_count': reviewsCount,
      'working_hours': workingHours,
      'is_open': isOpen,
      'tags': tags,
      'address': address,
      'phone_number': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  ServiceCenterEntity toEntity() => this;
}
