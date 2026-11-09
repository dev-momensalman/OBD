import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/core/errors/failures.dart';
import 'package:obd_vision/core/utils/result.dart';
import 'package:obd_vision/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:obd_vision/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:obd_vision/features/profile/domain/entities/user_profile_entity.dart';
import 'package:obd_vision/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:obd_vision/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:obd_vision/features/profile/presentation/bloc/profile_state.dart';

void main() {
  group('Profile Clean Architecture Isolation', () {
    late MockProfileRemoteDataSource dataSource;
    late ProfileRepositoryImpl repository;
    late GetUserProfileUseCase useCase;
    late ProfileCubit cubit;

    setUp(() {
      dataSource = MockProfileRemoteDataSource();
      repository = ProfileRepositoryImpl(dataSource);
      useCase = GetUserProfileUseCase(repository);
      cubit = ProfileCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('UseCase loads UserProfileEntity with expected vehicle and serial', () async {
      final result = await useCase();

      expect(result.isSuccess, isTrue);
      final Success<UserProfileEntity, Failure> successResult =
          result as Success<UserProfileEntity, Failure>;
      final profile = successResult.data;
      expect(profile.username, equals('youssefgad_26'));
      expect(profile.vehicleName, equals('Corolla 2018'));
      expect(profile.deviceSerial, contains('CPH2325'));
    });

    test('ProfileCubit loads and emits ProfileLoaded state successfully', () async {
      await cubit.fetchProfile();

      expect(cubit.state, isA<ProfileLoaded>());
      final loaded = cubit.state as ProfileLoaded;
      expect(loaded.profile.displayName, equals('Youssef Gad'));
    });
  });
}
