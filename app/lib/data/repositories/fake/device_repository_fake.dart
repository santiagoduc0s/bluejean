import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class DeviceRepositoryFake implements DeviceRepository {
  final String _identifier = 'fake-device-001';

  final List<DeviceEntity> _devices = [
    DeviceEntity(
      id: 1,
      identifier: 'fake-device-001',
      model: 'iPhone (Fake)',
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    ),
  ];

  @override
  Future<DeviceEntity> upsertDevice({String? fcmToken}) async => _devices.first;

  @override
  Future<void> unlinkDevice(String identifier) async {
    _devices.removeWhere((d) => d.identifier == identifier);
  }

  @override
  Future<List<DeviceEntity>> getDevices() async => List.of(_devices);

  @override
  Future<String> getDeviceIdentifier() async => _identifier;
}
