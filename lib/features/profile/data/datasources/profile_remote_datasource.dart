import '../models/user_profile_model.dart';

abstract class IProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> updateProfile(UserProfileModel model);
}

class MockProfileRemoteDataSource implements IProfileRemoteDataSource {
  UserProfileModel _profile = const UserProfileModel(
    id: 'usr_yg_26',
    username: 'youssefgad_26',
    email: 'youssef.gad@driver.com',
    displayName: 'Youssef Gad',
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
