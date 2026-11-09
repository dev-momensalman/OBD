import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:obd_vision/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:obd_vision/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:obd_vision/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:obd_vision/features/diagnostics/data/datasources/mock_obd_datasource.dart';
import 'package:obd_vision/features/diagnostics/data/repositories/obd_repository_impl.dart';
import 'package:obd_vision/features/diagnostics/domain/repositories/i_obd_repository.dart';
import 'package:obd_vision/features/diagnostics/domain/services/rule_engine.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/get_connection_status_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/run_diagnostic_scan_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/stream_live_telemetry_usecase.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies({SharedPreferences? preferences}) async {
  // External & Local Storage
  final SharedPreferences prefs =
      preferences ?? await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));

  // Domain Services
  sl.registerLazySingleton<RuleEngine>(() => const RuleEngine());

  // Data Sources
  sl.registerLazySingleton<MockObdDataSource>(() => MockObdDataSource());
  sl.registerLazySingleton<IAuthRemoteDataSource>(() => MockAuthRemoteDataSource());

  // Repositories
  sl.registerLazySingleton<IObdRepository>(
    () => ObdRepositoryImpl(
      mockDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton<StreamLiveTelemetryUseCase>(
    () => StreamLiveTelemetryUseCase(sl()),
  );
  sl.registerLazySingleton<RunDiagnosticScanUseCase>(
    () => RunDiagnosticScanUseCase(
      repository: sl(),
      ruleEngine: sl(),
    ),
  );
  sl.registerLazySingleton<GetConnectionStatusUseCase>(
    () => GetConnectionStatusUseCase(sl()),
  );
  sl.registerLazySingleton<SignInWithEmailUseCase>(
    () => SignInWithEmailUseCase(sl()),
  );
  sl.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(sl()),
  );

  // Cubits / Blocs
  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      streamLiveTelemetryUseCase: sl(),
      runDiagnosticScanUseCase: sl(),
      getConnectionStatusUseCase: sl(),
    ),
  );
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      signInWithEmailUseCase: sl(),
      signInWithGoogleUseCase: sl(),
    ),
  );
}
