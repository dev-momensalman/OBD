import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import '../../domain/entities/vehicle_entity.dart';
import 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final AppPreferences? _preferences;

  VehicleCubit({AppPreferences? preferences})
      : _preferences = preferences,
        super(VehicleInitial()) {
    _hydrateSavedVehicles();
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

  void _hydrateSavedVehicles() {
    final raw = _preferences?.savedVehiclesJson;
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final restored = decoded.whereType<Map<String, dynamic>>().map((m) {
        return VehicleEntity(
          id: m['id'] as String? ?? 'veh_saved',
          name: m['name'] as String? ?? 'Vehicle',
          nickname: m['nickname'] as String? ?? '',
          brand: m['brand'] as String? ?? '',
          modelYear: m['modelYear'] as String? ?? '2020',
          fuelType: m['fuelType'] as String? ?? 'Petrol',
          mileage: m['mileage'] as String? ?? '0 km',
          plateNumber: m['plateNumber'] as String? ?? '',
          vin: m['vin'] as String? ?? '',
          isCurrent: m['isCurrent'] as bool? ?? false,
        );
      }).toList();
      if (restored.isNotEmpty) {
        _vehicles = restored;
      }
    } catch (_) {}
  }

  Future<void> _persistVehicles() async {
    if (_preferences == null) return;
    final list = _vehicles
        .map(
          (v) => {
            'id': v.id,
            'name': v.name,
            'nickname': v.nickname,
            'brand': v.brand,
            'modelYear': v.modelYear,
            'fuelType': v.fuelType,
            'mileage': v.mileage,
            'plateNumber': v.plateNumber,
            'vin': v.vin,
            'isCurrent': v.isCurrent,
          },
        )
        .toList();
    await _preferences.setSavedVehiclesJson(jsonEncode(list));
  }

  void loadVehicles() {
    emit(VehicleLoading());
    if (_vehicles.isEmpty) {
      _vehicles = List.from(_initialVehicles);
    }
    final current = _vehicles.firstWhere(
      (v) => v.isCurrent,
      orElse: () => _vehicles.first,
    );
    emit(VehicleLoaded(
      vehicles: List.unmodifiable(_vehicles),
      currentVehicle: current,
    ));
  }

  void selectCurrentVehicle(String id) {
    _vehicles = _vehicles.map((v) => v.copyWith(isCurrent: v.id == id)).toList();
    _persistVehicles();
    loadVehicles();
  }

  void addVehicle(VehicleEntity vehicle, {bool makeCurrent = true}) {
    if (makeCurrent) {
      _vehicles = _vehicles.map((v) => v.copyWith(isCurrent: false)).toList();
    }
    _vehicles.add(vehicle.copyWith(isCurrent: makeCurrent));
    _persistVehicles();
    loadVehicles();
  }

  void updateVehicle(VehicleEntity updatedVehicle) {
    final index = _vehicles.indexWhere((v) => v.id == updatedVehicle.id);
    if (index != -1) {
      _vehicles[index] = updatedVehicle;
      _persistVehicles();
      loadVehicles();
    }
  }

  void deleteVehicle(String id) {
    if (_vehicles.length <= 1) return;
    final wasCurrent = _vehicles.any((v) => v.id == id && v.isCurrent);
    _vehicles.removeWhere((v) => v.id == id);
    if (wasCurrent && _vehicles.isNotEmpty) {
      _vehicles[0] = _vehicles[0].copyWith(isCurrent: true);
    }
    _persistVehicles();
    loadVehicles();
  }

  void resetForLogout() {
    _vehicles = List.from(_initialVehicles);
    _preferences?.setSavedVehiclesJson(null);
    loadVehicles();
  }
}
