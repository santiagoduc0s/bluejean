import 'package:lune/domain/entities/entities.dart';

abstract class DeviceRepository {
  Future<List<DeviceEntity>> getDevices();

  Future<DeviceEntity?> getCurrentDevice();

  Future<DeviceEntity> createDevice();

  Future<void> updateDevice({String? fcmToken});

  Future<void> linkDevice();

  Future<void> unlinkDevice(String deviceId);

  Future<void> unlinkCurrentDevice();
}
