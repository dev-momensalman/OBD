import '../../domain/entities/activity_log_entity.dart';

abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<ActivityLogEntity> logs;
  final String activeFilter;

  const HistoryLoaded({
    required this.logs,
    this.activeFilter = 'All',
  });
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
}
