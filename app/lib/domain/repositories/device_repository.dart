import 'package:lune/domain/entities/entities.dart';

abstract class DeviceRepository {
  Future<DeviceEntity> upsertDevice({String? fcmToken});
  Future<void> unlinkDevice(String identifier);
  Future<List<DeviceEntity>> getDevices();
  Future<String> getDeviceIdentifier();
}
