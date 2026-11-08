import '../entities/connection_status.dart';
import '../repositories/i_obd_repository.dart';

class GetConnectionStatusUseCase {
  final IObdRepository _repository;

  const GetConnectionStatusUseCase(this._repository);

  Stream<ConnectionStatus> call() {
    return _repository.connectionStatusStream;
  }
}
