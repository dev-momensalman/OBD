import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_service_centers_usecase.dart';
import 'workshops_state.dart';

class WorkshopsCubit extends Cubit<WorkshopsState> {
  final GetServiceCentersUseCase _getServiceCentersUseCase;

  WorkshopsCubit(this._getServiceCentersUseCase) : super(const WorkshopsInitial());

  Future<void> fetchServiceCenters({String? query}) async {
    emit(const WorkshopsLoading());
    final result = await _getServiceCentersUseCase(query: query);

    result.when(
      success: (centers) => emit(WorkshopsLoaded(
        centers: centers,
        activeSearchQuery: query ?? '',
      )),
      error: (failure) => emit(WorkshopsError(failure.message)),
    );
  }

  void filterCenters(String query) {
    fetchServiceCenters(query: query);
  }
}
