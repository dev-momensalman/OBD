import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vehicle_entity.dart';
import 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleInitial()) {
    loadVehicles();
  }

  static const List<VehicleEntity> _initialVehicles = [
    VehicleEntity(
      id: 'veh_01',
      name: 'Corolla 2018',
      nickname: 'My daily car',
      brand: 'Toyota',
      modelYear: '2018',
      fuelType: 'Petrol',
      mileage: '84,200 km',
      plateNumber: '4821 KSA',
      vin: 'JTDBR32E820194821',
      isCurrent: true,
    ),
    VehicleEntity(
      id: 'veh_02',
      name: 'Elantra 2020',
      nickname: 'Family car',
      brand: 'Hyundai',
      modelYear: '2020',
      fuelType: 'Petrol',
      mileage: '41,500 km',
      plateNumber: '7193 EGY',
      vin: 'KMHD35LE9LU384102',
      isCurrent: false,
    ),
  ];

  List<VehicleEntity> _vehicles = List.from(_initialVehicles);

  void loadVehicles() {
    emit(VehicleLoading());
    final current = _vehicles.firstWhere(
      (v) => v.isCurrent,
      orElse: () => _vehicles.first,
    );
    emit(VehicleLoaded(vehicles: List.unmodifiable(_vehicles), currentVehicle: current));
  }

  void selectCurrentVehicle(String id) {
    _vehicles = _vehicles.map((v) => v.copyWith(isCurrent: v.id == id)).toList();
    loadVehicles();
  }

  void addVehicle(VehicleEntity vehicle) {
    _vehicles.add(vehicle);
    loadVehicles();
  }

  void updateVehicle(VehicleEntity updatedVehicle) {
    final index = _vehicles.indexWhere((v) => v.id == updatedVehicle.id);
    if (index != -1) {
      _vehicles[index] = updatedVehicle;
      loadVehicles();
    }
  }
}
