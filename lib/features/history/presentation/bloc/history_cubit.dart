import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/features/diagnostics/domain/entities/diagnostic_report.dart';
import '../../data/models/activity_log_model.dart';
import '../../domain/entities/activity_log_entity.dart';
import '../../domain/usecases/get_diagnostic_history_usecase.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetDiagnosticHistoryUseCase _getDiagnosticHistoryUseCase;
  final AppPreferences? _preferences;
  final bool Function() _isArabic;
  final List<ActivityLogEntity> _sessionLogs = [];
  String _activeFilter = 'All';

  HistoryCubit(
    this._getDiagnosticHistoryUseCase, {
    AppPreferences? preferences,
    bool Function()? isArabic,
  })  : _preferences = preferences,
        _isArabic = isArabic ?? _defaultIsArabic,
        super(const HistoryInitial()) {
    _loadSavedLogs();
  }

  void _loadSavedLogs() {
    final raw = _preferences?.savedHistoryLogsJson;
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      for (final item in list.whereType<Map<String, dynamic>>()) {
        _sessionLogs.add(ActivityLogModel.fromJson(item));
      }
    } catch (_) {}
  }

  Future<void> _persistSessionLogs() async {
    if (_preferences == null) return;
    final serialized = _sessionLogs
        .take(30)
        .map(
          (l) => ActivityLogModel(
            id: l.id,
            date: l.date,
            title: l.title,
            subtitle: l.subtitle,
            healthScore: l.healthScore,
            isWarning: l.isWarning,
            severity: l.severity,
            detectedDtcs: l.detectedDtcs,
            sensorsRecorded: l.sensorsRecorded,
          ).toJson(),
        )
        .toList();
    await _preferences.setSavedHistoryLogsJson(jsonEncode(serialized));
  }

  static bool _defaultIsArabic() => false;

  Future<void> fetchHistory({String? filterCategory}) async {
    _activeFilter = filterCategory ?? 'All';
    emit(const HistoryLoading());
    final result =
        await _getDiagnosticHistoryUseCase(filterCategory: filterCategory);

    result.when(
      success: (logs) {
        final filteredSession = _filterSessionLogs(_activeFilter);
        emit(HistoryLoaded(
          logs: [...filteredSession, ...logs],
          activeFilter: _activeFilter,
        ));
      },
      error: (failure) => emit(HistoryError(failure.message)),
    );
  }

  void changeFilter(String filter) {
    fetchHistory(filterCategory: filter == 'All' ? null : filter);
  }

  /// Records a newly completed diagnostic scan into the live history feed.
  void recordScanReport(DiagnosticReport report) {
    final arabic = _isArabic();
    final hasFaults = report.dtcs.isNotEmpty;
    final dtcSummary = report.dtcs.map((d) => d.code).join(', ');
    final log = ActivityLogEntity(
      id: report.id,
      date: arabic ? 'الآن' : 'Just now',
      title: hasFaults
          ? (report.dtcs.first.description)
          : (arabic ? 'فحص شامل لحالة النظام' : 'Full System Health Scan'),
      subtitle: hasFaults
          ? '$dtcSummary · ${report.diagnosisSource}'
          : (arabic
              ? 'كافة الأنظمة تعمل بكفاءة · ${report.diagnosisSource}'
              : 'All systems nominal · ${report.diagnosisSource}'),
      healthScore: report.vehicleHealthScore,
      isWarning: hasFaults || report.vehicleHealthScore < 90,
      severity: report.overallSeverity.name.toUpperCase(),
      detectedDtcs: report.dtcs.map((d) => d.code).toList(),
      sensorsRecorded: 24,
    );

    _sessionLogs.removeWhere((item) => item.id == log.id);
    _sessionLogs.insert(0, log);
    _persistSessionLogs();

    if (state is HistoryLoaded) {
      final current = state as HistoryLoaded;
      final existingBase = current.logs
          .where((l) => !_sessionLogs.any((s) => s.id == l.id))
          .toList();
      emit(HistoryLoaded(
        logs: [..._filterSessionLogs(current.activeFilter), ...existingBase],
        activeFilter: current.activeFilter,
      ));
    }
  }

  void clearSession() {
    _sessionLogs.clear();
    _activeFilter = 'All';
    _preferences?.setSavedHistoryLogsJson(null);
    emit(const HistoryInitial());
  }

  List<ActivityLogEntity> _filterSessionLogs(String filter) {
    if (filter == 'Faults') {
      return _sessionLogs.where((l) => l.isWarning).toList();
    }
    if (filter == 'Routine' || filter == 'Trips') {
      return _sessionLogs.where((l) => !l.isWarning).toList();
    }
    return List<ActivityLogEntity>.from(_sessionLogs);
  }
}
