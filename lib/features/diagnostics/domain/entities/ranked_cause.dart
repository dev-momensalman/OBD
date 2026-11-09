import 'package:equatable/equatable.dart';

/// Strongly-typed domain entity representing a probabilistic root cause identified during vehicle diagnosis.
class RankedCause extends Equatable {
  final String cause;
  final double probability;
  final String description;

  const RankedCause({
    required this.cause,
    required this.probability,
    this.description = '',
  });

  @override
  List<Object?> get props => [cause, probability, description];
}
