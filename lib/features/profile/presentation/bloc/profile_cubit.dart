import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/features/auth/domain/repositories/i_auth_repository.dart';
import '../../data/models/user_profile_model.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final IProfileRepository? _profileRepository;
  final IAuthRepository? _authRepository;
  final AppPreferences? _preferences;

  ProfileCubit(
    this._getUserProfileUseCase, {
    IProfileRepository? profileRepository,
    IAuthRepository? authRepository,
    AppPreferences? preferences,
  })  : _profileRepository = profileRepository,
        _authRepository = authRepository,
        _preferences = preferences,
        super(const ProfileInitial());

  UserProfileEntity? _readSavedProfile() {
    final raw = _preferences?.savedProfileJson;
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserProfileModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      ).toEntity();
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveProfileLocally(UserProfileEntity profile) async {
    if (_preferences == null) return;
    final model = UserProfileModel(
      id: profile.id,
      username: profile.username,
      email: profile.email,
      displayName: profile.displayName,
      avatarUrl: profile.avatarUrl,
      vehicleName: profile.vehicleName,
      deviceSerial: profile.deviceSerial,
      preferredLanguage: profile.preferredLanguage,
    );
    await _preferences.setSavedProfileJson(jsonEncode(model.toJson()));
  }

  Future<void> fetchProfile() async {
    emit(const ProfileLoading());
    final result = await _getUserProfileUseCase();

    result.when(
      success: (profile) {
        final saved = _readSavedProfile();
        final base = saved ?? profile;
        final authUser = _authRepository?.currentUser;
        final activatedSerial = _preferences?.activatedSerial;
        final effectiveSerial = (activatedSerial != null && activatedSerial.isNotEmpty)
            ? activatedSerial
            : base.deviceSerial;

        if (authUser != null) {
          final merged = UserProfileEntity(
            id: authUser.id,
            username: saved != null && saved.id == authUser.id
                ? saved.username
                : (authUser.displayName?.isNotEmpty == true
                    ? authUser.displayName!
                    : base.username),
            email: authUser.email.isNotEmpty ? authUser.email : base.email,
            displayName: saved != null && saved.id == authUser.id
                ? saved.displayName
                : (authUser.displayName?.isNotEmpty == true
                    ? authUser.displayName!
                    : base.displayName),
            avatarUrl: authUser.photoUrl ?? base.avatarUrl,
            vehicleName: base.vehicleName,
            deviceSerial: effectiveSerial,
            preferredLanguage: base.preferredLanguage,
          );
          emit(ProfileLoaded(merged));
        } else {
          emit(ProfileLoaded(UserProfileEntity(
            id: base.id,
            username: base.username,
            email: base.email,
            displayName: base.displayName,
            avatarUrl: base.avatarUrl,
            vehicleName: base.vehicleName,
            deviceSerial: effectiveSerial,
            preferredLanguage: base.preferredLanguage,
          )));
        }
      },
      error: (failure) => emit(ProfileError(failure.message)),
    );
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final fullName = '$firstName $lastName'.trim();
    final current = state is ProfileLoaded
        ? (state as ProfileLoaded).profile
        : (_readSavedProfile() ??
            const UserProfileEntity(
              id: 'usr_ms_26',
              username: 'momen salman',
              email: 'momensalman.dev@gmail.com',
              displayName: 'momen salman',
              vehicleName: 'Corolla 2018',
              deviceSerial: 'OBD-II v2.4 (CPH2325)',
              preferredLanguage: 'English',
            ));

    final updated = UserProfileEntity(
      id: current.id,
      username: fullName.isEmpty ? current.username : fullName,
      email: email.trim().isEmpty ? current.email : email.trim(),
      displayName: fullName.isEmpty ? current.displayName : fullName,
      avatarUrl: current.avatarUrl,
      vehicleName: current.vehicleName,
      deviceSerial: current.deviceSerial,
      preferredLanguage: current.preferredLanguage,
    );

    if (_profileRepository != null) {
      await _profileRepository.updateProfile(updated);
    }
    await _saveProfileLocally(updated);
    emit(ProfileLoaded(updated));
  }

  void clearSession() {
    _preferences?.setSavedProfileJson(null);
    emit(const ProfileInitial());
  }
}
