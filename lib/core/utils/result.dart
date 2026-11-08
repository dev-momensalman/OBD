import 'package:equatable/equatable.dart';

sealed class Result<S, F> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isError => this is Err<S, F>;

  S? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        Err() => null,
      };

  F? get errorOrNull => switch (this) {
        Success() => null,
        Err(error: final e) => e,
      };

  R when<R>({
    required R Function(S data) success,
    required R Function(F error) error,
  }) {
    return switch (this) {
      Success(data: final d) => success(d),
      Err(error: final e) => error(e),
    };
  }
}

final class Success<S, F> extends Result<S, F> {
  final S data;
  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

final class Err<S, F> extends Result<S, F> {
  final F error;
  const Err(this.error);

  @override
  List<Object?> get props => [error];
}
