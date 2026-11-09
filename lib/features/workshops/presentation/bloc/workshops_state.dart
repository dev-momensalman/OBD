import '../../domain/entities/service_center_entity.dart';

abstract class WorkshopsState {
  const WorkshopsState();
}

class WorkshopsInitial extends WorkshopsState {
  const WorkshopsInitial();
}

class WorkshopsLoading extends WorkshopsState {
  const WorkshopsLoading();
}

class WorkshopsLoaded extends WorkshopsState {
  final List<ServiceCenterEntity> centers;
  final String activeSearchQuery;

  const WorkshopsLoaded({
    required this.centers,
    this.activeSearchQuery = '',
  });
}

class WorkshopsError extends WorkshopsState {
  final String message;
  const WorkshopsError(this.message);
}
