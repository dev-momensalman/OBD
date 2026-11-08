import 'package:get_it/get_it.dart';
import 'package:obd_vision/features/diagnostics/data/datasources/mock_obd_datasource.dart';
import 'package:obd_vision/features/diagnostics/data/repositories/obd_repository_impl.dart';
import 'package:obd_vision/features/diagnostics/domain/repositories/i_obd_repository.dart';
import 'package:obd_vision/features/diagnostics/domain/services/rule_engine.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/get_connection_status_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/run_diagnostic_scan_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/stream_live_telemetry_usecase.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Domain Services
  sl.registerLazySingleton<RuleEngine>(() => const RuleEngine());

  // Data Sources
  sl.registerLazySingleton<MockObdDataSource>(() => MockObdDataSource());

  // Repositories
  sl.registerLazySingleton<IObdRepository>(
    () => ObdRepositoryImpl(
      mockDataSource: sl(),
      ruleEngine: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<StreamLiveTelemetryUseCase>(
    () => StreamLiveTelemetryUseCase(sl()),
  );
  sl.registerLazySingleton<RunDiagnosticScanUseCase>(
    () => RunDiagnosticScanUseCase(sl()),
  );
  sl.registerLazySingleton<GetConnectionStatusUseCase>(
    () => GetConnectionStatusUseCase(sl()),
  );

  // Cubits / Blocs
  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      streamLiveTelemetryUseCase: sl(),
      runDiagnosticScanUseCase: sl(),
      getConnectionStatusUseCase: sl(),
    ),
  );
}
