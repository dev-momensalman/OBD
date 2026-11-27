import '../models/activity_log_model.dart';

abstract class IHistoryRemoteDataSource {
  Future<List<ActivityLogModel>> getDiagnosticHistory({String? filterCategory});
}

class MockHistoryRemoteDataSource implements IHistoryRemoteDataSource {
  @override
  Future<List<ActivityLogModel>> getDiagnosticHistory({String? filterCategory}) async {
    await Future.delayed(const Duration(milliseconds: 350));

    final rawJson = [
      {
        'id': 'scan_101',
        'date': 'Today, 09:40',
        'title': 'High Coolant Temp & Misfire',
        'subtitle': 'P0301, P0171 detected · 24 sensors recorded',
        'health_score': 86,
        'is_warning': true,
        'severity': 'Warning',
        'detected_dtcs': ['P0301', 'P0171'],
        'sensors_recorded': 24,
      },
      {
        'id': 'scan_102',
        'date': 'Yesterday, 14:15',
        'title': 'Routine System Pre-Check',
        'subtitle': 'All electronic control units responding',
        'health_score': 98,
        'is_warning': false,
        'severity': 'Normal',
        'detected_dtcs': [],
        'sensors_recorded': 27,
      },
      {
        'id': 'scan_103',
        'date': '3 days ago',
        'title': 'Battery Alternator Fluctuation',
        'subtitle': 'Voltage dipped to 12.1V under engine load',
        'health_score': 91,
        'is_warning': true,
        'severity': 'Mild',
        'detected_dtcs': ['P0562'],
        'sensors_recorded': 18,
      },
      {
        'id': 'scan_104',
        'date': '1 week ago',
        'title': 'Scheduled Full Vehicle Diagnostic',
        'subtitle': 'Powertrain, ABS & SRS full sweep passed',
        'health_score': 100,
        'is_warning': false,
        'severity': 'Optimal',
        'detected_dtcs': [],
        'sensors_recorded': 32,
      },
    ];

    final models = rawJson.map((j) => ActivityLogModel.fromJson(j)).toList();

    if (filterCategory == 'Faults') {
      return models.where((m) => m.isWarning).toList();
    } else if (filterCategory == 'Routine' || filterCategory == 'Trips') {
      return models.where((m) => !m.isWarning).toList();
    }

    return models;
  }
}
