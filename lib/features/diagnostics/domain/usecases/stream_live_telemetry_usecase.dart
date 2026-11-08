import '../entities/telemetry_snapshot.dart';
import '../repositories/i_obd_repository.dart';

class StreamLiveTelemetryUseCase {
  final IObdRepository _repository;

  const StreamLiveTelemetryUseCase(this._repository);

  Stream<TelemetrySnapshot> call() {
    return _repository.streamLiveTelemetry();
  }
}
