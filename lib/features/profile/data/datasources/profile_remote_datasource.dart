import '../models/user_profile_model.dart';

abstract class IProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> updateProfile(UserProfileModel model);
}

class MockProfileRemoteDataSource implements IProfileRemoteDataSource {
  UserProfileModel _profile = const UserProfileModel(
    id: 'usr_ms_26',
    username: 'momen salman',
    email: 'momensalman.dev@gmail.com',
    displayName: 'momen salman',
    vehicleName: 'Corolla 2018',
    deviceSerial: 'OBD-II v2.4 (CPH2325)',
    preferredLanguage: 'English',
  );

  @override
  Future<UserProfileModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _profile;
  }

  @override
  Future<void> updateProfile(UserProfileModel model) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profile = model;
  }
}
