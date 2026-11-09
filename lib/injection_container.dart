import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obd_vision/core/services/app_preferences.dart';

// Auth
import 'package:obd_vision/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:obd_vision/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:obd_vision/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:obd_vision/features/auth/presentation/bloc/auth_cubit.dart';

// Diagnostics
import 'package:obd_vision/features/diagnostics/data/datasources/mock_obd_datasource.dart';
import 'package:obd_vision/features/diagnostics/data/repositories/obd_repository_impl.dart';
import 'package:obd_vision/features/diagnostics/domain/repositories/i_obd_repository.dart';
import 'package:obd_vision/features/diagnostics/domain/services/rule_engine.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/get_connection_status_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/run_diagnostic_scan_usecase.dart';
import 'package:obd_vision/features/diagnostics/domain/usecases/stream_live_telemetry_usecase.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';

// Workshops & Service Centers
import 'package:obd_vision/features/workshops/data/datasources/workshops_remote_datasource.dart';
import 'package:obd_vision/features/workshops/data/repositories/workshops_repository_impl.dart';
import 'package:obd_vision/features/workshops/domain/repositories/i_workshops_repository.dart';
import 'package:obd_vision/features/workshops/domain/usecases/get_service_centers_usecase.dart';
import 'package:obd_vision/features/workshops/presentation/bloc/workshops_cubit.dart';

// Activity & History
import 'package:obd_vision/features/history/data/datasources/history_remote_datasource.dart';
import 'package:obd_vision/features/history/data/repositories/history_repository_impl.dart';
import 'package:obd_vision/features/history/domain/repositories/i_history_repository.dart';
import 'package:obd_vision/features/history/domain/usecases/get_diagnostic_history_usecase.dart';
import 'package:obd_vision/features/history/presentation/bloc/history_cubit.dart';

// User Profile
import 'package:obd_vision/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:obd_vision/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:obd_vision/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:obd_vision/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:obd_vision/features/profile/presentation/bloc/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies({SharedPreferences? preferences}) async {
  if (sl.isRegistered<AppPreferences>()) {
    return;
  }
  // External & Local Storage
  final SharedPreferences prefs =
      preferences ?? await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));

  // Domain Services
  sl.registerLazySingleton<RuleEngine>(() => const RuleEngine());

  // Data Sources (Swappable for Real HTTP / Firebase / Supabase APIs)
  sl.registerLazySingleton<MockObdDataSource>(() => MockObdDataSource());
  sl.registerLazySingleton<IAuthRemoteDataSource>(() => MockAuthRemoteDataSource());
  sl.registerLazySingleton<IWorkshopsRemoteDataSource>(() => MockWorkshopsRemoteDataSource());
  sl.registerLazySingleton<IHistoryRemoteDataSource>(() => MockHistoryRemoteDataSource());
  sl.registerLazySingleton<IProfileRemoteDataSource>(() => MockProfileRemoteDataSource());

  // Repositories
  sl.registerLazySingleton<IObdRepository>(
    () => ObdRepositoryImpl(
      mockDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<IWorkshopsRepository>(
    () => WorkshopsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<IHistoryRepository>(
    () => HistoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
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
  sl.registerLazySingleton<GetServiceCentersUseCase>(
    () => GetServiceCentersUseCase(sl()),
  );
  sl.registerLazySingleton<GetDiagnosticHistoryUseCase>(
    () => GetDiagnosticHistoryUseCase(sl()),
  );
  sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(sl()),
  );

  // Cubits / Blocs (Factory)
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
  sl.registerFactory<WorkshopsCubit>(
    () => WorkshopsCubit(sl()),
  );
  sl.registerFactory<HistoryCubit>(
    () => HistoryCubit(sl()),
  );
  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(sl()),
  );
}
