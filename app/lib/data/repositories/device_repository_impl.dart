import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/models/models.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl({
    required DeviceInfoService deviceInfoService,
    required ApiClient apiClient,
  }) : _deviceInfoService = deviceInfoService,
       _apiClient = apiClient;

  final DeviceInfoService _deviceInfoService;
  final ApiClient _apiClient;

  @override
  Future<DeviceEntity> upsertDevice({String? fcmToken}) async {
    final identifier = await _deviceInfoService.getDeviceId();
    final model = await _deviceInfoService.getDeviceModel();

    final response = await _apiClient.post(
      '/api/v1/devices',
      body: {
        'identifier': identifier,
        'model': model,
        if (fcmToken != null) 'fcm_token': fcmToken,
      },
    );

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      return DeviceModel.fromJson(data);
    }

    throw Exception('Failed to upsert device: ${response.body}');
  }

  @override
  Future<void> unlinkDevice(String identifier) async {
    final response = await _apiClient.post(
      '/api/v1/devices/unlink',
      body: {'identifier': identifier},
    );

    if (response.isError) {
      throw Exception('Failed to unlink device');
    }
  }

  @override
  Future<List<DeviceEntity>> getDevices() async {
    final response = await _apiClient.get('/api/v1/devices');

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as List<dynamic>;
      return data
          .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to get devices');
  }

  @override
  Future<String> getDeviceIdentifier() => _deviceInfoService.getDeviceId();
}
