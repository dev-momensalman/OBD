import '../models/service_center_model.dart';

abstract class IWorkshopsRemoteDataSource {
  Future<List<ServiceCenterModel>> getServiceCenters({String? query});
  Future<ServiceCenterModel> getServiceCenterById(String id);
}

class MockWorkshopsRemoteDataSource implements IWorkshopsRemoteDataSource {
  @override
  Future<List<ServiceCenterModel>> getServiceCenters({String? query}) async {
    // Simulate real network latency (400ms)
    await Future.delayed(const Duration(milliseconds: 400));

    final rawApiJson = [
      {
        'id': 'ws_001',
        'name': 'Al-Nour Service Center',
        'distance': '1.2 km',
        'rating': 4.7,
        'reviews_count': 230,
        'working_hours': 'Open until 8 PM',
        'is_open': true,
        'tags': ['Engine', 'Electrical', 'Compatible'],
        'address': 'Plot 14, Auto District, Cairo',
        'phone_number': '+201001234567',
        'latitude': 30.0444,
        'longitude': 31.2357,
      },
      {
        'id': 'ws_002',
        'name': 'Speed Auto Care',
        'distance': '2.8 km',
        'rating': 4.5,
        'reviews_count': 118,
        'working_hours': 'Open until 6 PM',
        'is_open': true,
        'tags': ['Brakes', 'AC', 'Compatible'],
        'address': 'Ring Road Exit 8, Giza',
        'phone_number': '+201009876543',
        'latitude': 30.0131,
        'longitude': 31.2089,
      },
      {
        'id': 'ws_003',
        'name': 'Delta Garage',
        'distance': '4.1 km',
        'rating': 4.2,
        'reviews_count': 64,
        'working_hours': 'Closed, opens 9 AM',
        'is_open': false,
        'tags': ['Engine', 'Tires', 'Compatible'],
        'address': 'Nasr City, Zone 6',
        'phone_number': '+201005554321',
        'latitude': 30.0561,
        'longitude': 31.3301,
      },
      {
        'id': 'ws_004',
        'name': 'Precision Tune Auto Care',
        'distance': '3.5 km',
        'rating': 4.6,
        'reviews_count': 95,
        'working_hours': 'Open until 7 PM',
        'is_open': true,
        'tags': ['Transmission', 'Suspension', 'Compatible'],
        'address': 'Sheraton Heliopolis',
        'phone_number': '+201007778899',
        'latitude': 30.0912,
        'longitude': 31.3789,
      },
    ];

    final models = rawApiJson
        .map((j) => ServiceCenterModel.fromJson(j))
        .toList();

    if (query != null && query.trim().isNotEmpty) {
      return models
          .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return models;
  }

  @override
  Future<ServiceCenterModel> getServiceCenterById(String id) async {
    final list = await getServiceCenters();
    return list.firstWhere(
      (m) => m.id == id,
      orElse: () => list.first,
    );
  }
}
