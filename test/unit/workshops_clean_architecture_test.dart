import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import 'package:obd_vision/features/workshops/data/datasources/workshops_remote_datasource.dart';
import 'package:obd_vision/features/workshops/data/repositories/workshops_repository_impl.dart';
import 'package:obd_vision/features/workshops/domain/entities/service_center_entity.dart';
import 'package:obd_vision/features/workshops/domain/usecases/get_service_centers_usecase.dart';
import 'package:obd_vision/features/workshops/presentation/bloc/workshops_cubit.dart';
import 'package:obd_vision/features/workshops/presentation/bloc/workshops_state.dart';

void main() {
  group('Workshops Clean Architecture Layer Isolation', () {
    late MockWorkshopsRemoteDataSource dataSource;
    late WorkshopsRepositoryImpl repository;
    late GetServiceCentersUseCase useCase;
    late WorkshopsCubit cubit;

    setUp(() {
      dataSource = MockWorkshopsRemoteDataSource();
      repository = WorkshopsRepositoryImpl(dataSource);
      useCase = GetServiceCentersUseCase(repository);
      cubit = WorkshopsCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('UseCase returns Success with ServiceCenterEntity list from MockDataSource', () async {
      final result = await useCase();

      expect(result.isSuccess, isTrue);
      final Success<List<ServiceCenterEntity>, Failure> successResult =
          result as Success<List<ServiceCenterEntity>, Failure>;
      final centers = successResult.data;
      expect(centers.length, equals(4));
      expect(centers.first.name, contains('Al-Nour'));
      expect(centers.first.rating, equals(4.7));
    });

    test('Cubit loads and emits WorkshopsLoaded state', () async {
      await cubit.fetchServiceCenters();

      expect(cubit.state, isA<WorkshopsLoaded>());
      final loaded = cubit.state as WorkshopsLoaded;
      expect(loaded.centers.length, equals(4));
    });

    test('Cubit filters service centers by search query in memory', () async {
      await cubit.fetchServiceCenters();
      expect((cubit.state as WorkshopsLoaded).centers.length, equals(4));

      await cubit.fetchServiceCenters(query: 'Speed');
      expect((cubit.state as WorkshopsLoaded).centers.length, equals(1));
      expect((cubit.state as WorkshopsLoaded).centers.first.name, contains('Speed'));
    });
  });
}
