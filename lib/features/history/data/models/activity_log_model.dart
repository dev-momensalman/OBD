import '../../domain/entities/activity_log_entity.dart';

class ActivityLogModel extends ActivityLogEntity {
  const ActivityLogModel({
    required super.id,
    required super.date,
    required super.title,
    required super.subtitle,
    required super.healthScore,
    required super.isWarning,
    required super.severity,
    super.detectedDtcs,
    super.sensorsRecorded,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? json['created_at'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      healthScore: json['health_score'] as int? ?? json['healthScore'] as int? ?? 100,
      isWarning: json['is_warning'] as bool? ?? json['isWarning'] as bool? ?? false,
      severity: json['severity'] as String? ?? 'Normal',
      detectedDtcs: (json['detected_dtcs'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      sensorsRecorded: json['sensors_recorded'] as int? ?? json['sensorsRecorded'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'subtitle': subtitle,
      'health_score': healthScore,
      'is_warning': isWarning,
      'severity': severity,
      'detected_dtcs': detectedDtcs,
      'sensors_recorded': sensorsRecorded,
    };
  }

  ActivityLogEntity toEntity() => this;
}
