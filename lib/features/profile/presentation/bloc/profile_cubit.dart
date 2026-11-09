import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;

  ProfileCubit(this._getUserProfileUseCase) : super(const ProfileInitial());

  Future<void> fetchProfile() async {
    emit(const ProfileLoading());
    final result = await _getUserProfileUseCase();

    result.when(
      success: (profile) => emit(ProfileLoaded(profile)),
      error: (failure) => emit(ProfileError(failure.message)),
    );
  }
}
