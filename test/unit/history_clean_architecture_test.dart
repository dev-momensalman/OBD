import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import 'package:obd_vision/features/history/data/datasources/history_remote_datasource.dart';
import 'package:obd_vision/features/history/data/repositories/history_repository_impl.dart';
import 'package:obd_vision/features/history/domain/entities/activity_log_entity.dart';
import 'package:obd_vision/features/history/domain/usecases/get_diagnostic_history_usecase.dart';
import 'package:obd_vision/features/history/presentation/bloc/history_cubit.dart';
import 'package:obd_vision/features/history/presentation/bloc/history_state.dart';

void main() {
  group('Diagnostic History Clean Architecture Isolation', () {
    late MockHistoryRemoteDataSource dataSource;
    late HistoryRepositoryImpl repository;
    late GetDiagnosticHistoryUseCase useCase;
    late HistoryCubit cubit;

    setUp(() {
      dataSource = MockHistoryRemoteDataSource();
      repository = HistoryRepositoryImpl(dataSource);
      useCase = GetDiagnosticHistoryUseCase(repository);
      cubit = HistoryCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('UseCase retrieves full list of ActivityLogEntity successfully', () async {
      final result = await useCase();

      expect(result.isSuccess, isTrue);
      final Success<List<ActivityLogEntity>, Failure> successResult =
          result as Success<List<ActivityLogEntity>, Failure>;
      final logs = successResult.data;
      expect(logs.length, equals(4));
      expect(logs.first.title, contains('High Coolant Temp'));
      expect(logs.first.isWarning, isTrue);
    });

    test('UseCase filters by Faults correctly', () async {
      final result = await useCase(filterCategory: 'Faults');

      expect(result.isSuccess, isTrue);
      final Success<List<ActivityLogEntity>, Failure> successResult =
          result as Success<List<ActivityLogEntity>, Failure>;
      final logs = successResult.data;
      expect(logs.every((ActivityLogEntity l) => l.isWarning), isTrue);
    });

    test('Cubit manages filter state and emits HistoryLoaded', () async {
      await cubit.fetchHistory();

      expect(cubit.state, isA<HistoryLoaded>());
      final loaded = cubit.state as HistoryLoaded;
      expect(loaded.logs.length, equals(4));
      expect(loaded.activeFilter, equals('All'));
    });
  });
}
