import 'package:equatable/equatable.dart';

/// Clean Architecture Domain Entity for User Vehicles (Aggregate Root)
class VehicleEntity extends Equatable {
  final String id;
  final String name;
  final String nickname;
  final String brand;
  final String modelYear;
  final String fuelType;
  final String mileage;
  final String plateNumber;
  final String vin;
  final bool isCurrent;

  const VehicleEntity({
    required this.id,
    required this.name,
    required this.nickname,
    required this.brand,
    required this.modelYear,
    required this.fuelType,
    required this.mileage,
    required this.plateNumber,
    required this.vin,
    this.isCurrent = false,
  });

  VehicleEntity copyWith({
    String? id,
    String? name,
    String? nickname,
    String? brand,
    String? modelYear,
    String? fuelType,
    String? mileage,
    String? plateNumber,
    String? vin,
    bool? isCurrent,
  }) {
    return VehicleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      brand: brand ?? this.brand,
      modelYear: modelYear ?? this.modelYear,
      fuelType: fuelType ?? this.fuelType,
      mileage: mileage ?? this.mileage,
      plateNumber: plateNumber ?? this.plateNumber,
      vin: vin ?? this.vin,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nickname,
        brand,
        modelYear,
        fuelType,
        mileage,
        plateNumber,
        vin,
        isCurrent,
      ];
}
