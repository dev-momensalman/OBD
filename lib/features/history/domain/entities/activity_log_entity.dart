class ActivityLogEntity {
  final String id;
  final String date;
  final String title;
  final String subtitle;
  final int healthScore;
  final bool isWarning;
  final String severity;
  final List<String> detectedDtcs;
  final int sensorsRecorded;

  const ActivityLogEntity({
    required this.id,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.healthScore,
    required this.isWarning,
    required this.severity,
    this.detectedDtcs = const [],
    this.sensorsRecorded = 0,
  });
}
