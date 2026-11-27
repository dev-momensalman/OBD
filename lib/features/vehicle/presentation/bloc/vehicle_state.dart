import 'package:equatable/equatable.dart';
import '../../domain/entities/vehicle_entity.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  VehicleEntity? get activeVehicle =>
      this is VehicleLoaded ? (this as VehicleLoaded).currentVehicle : null;

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<VehicleEntity> vehicles;
  final VehicleEntity currentVehicle;

  const VehicleLoaded({
    required this.vehicles,
    required this.currentVehicle,
  });

  @override
  List<Object?> get props => [vehicles, currentVehicle];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}
