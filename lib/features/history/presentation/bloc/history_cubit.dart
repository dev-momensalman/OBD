import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_diagnostic_history_usecase.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetDiagnosticHistoryUseCase _getDiagnosticHistoryUseCase;

  HistoryCubit(this._getDiagnosticHistoryUseCase) : super(const HistoryInitial());

  Future<void> fetchHistory({String? filterCategory}) async {
    emit(const HistoryLoading());
    final result = await _getDiagnosticHistoryUseCase(filterCategory: filterCategory);

    result.when(
      success: (logs) => emit(HistoryLoaded(
        logs: logs,
        activeFilter: filterCategory ?? 'All',
      )),
      error: (failure) => emit(HistoryError(failure.message)),
    );
  }

  void changeFilter(String filter) {
    fetchHistory(filterCategory: filter == 'All' ? null : filter);
  }
}
