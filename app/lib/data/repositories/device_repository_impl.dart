import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/models/models.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl({
    required DeviceInfoService deviceInfoService,
    required ApiClient apiClient,
  })  : _deviceInfoService = deviceInfoService,
        _apiClient = apiClient;

  final DeviceInfoService _deviceInfoService;
  final ApiClient _apiClient;

  @override
  Future<List<DeviceEntity>> getDevices() async {
    final response = await _apiClient.get('/api/v1/devices');

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as List<dynamic>;
      return data
          .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get devices');
    }
  }

  @override
  Future<DeviceEntity?> getCurrentDevice() async {
    final deviceId = await _deviceInfoService.getDeviceId();

    if (await _apiClient.isAuthenticated()) {
      return _getCurrentAuthDevice(deviceId);
    } else {
      return _getCurrentUnAuthDevice(deviceId);
    }
  }

  Future<DeviceEntity?> _getCurrentAuthDevice(String deviceId) async {
    try {
      final response = await _apiClient.get(
        'api/v1/devices/me',
        queryParameters: {
          'identifier': deviceId,
        },
      );

      if (response.isSuccess) {
        final data = response.jsonBody['data'] as Map<String, dynamic>;
        return DeviceModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<DeviceEntity?> _getCurrentUnAuthDevice(String deviceId) async {
    try {
      final response = await _apiClient.get(
        'api/v1/devices/by-identifier',
        queryParameters: {
          'identifier': deviceId,
        },
      );

      if (response.isSuccess) {
        final data = response.jsonBody['data'] as Map<String, dynamic>;
        return DeviceModel.fromJson(data);
      } else {
        if (response.statusCode == 404) {
          await createDevice();

          final response = await _apiClient.get(
            'api/v1/devices/by-identifier',
            queryParameters: {
              'identifier': deviceId,
            },
          );

          if (response.isSuccess) {
            final data = response.jsonBody['data'] as Map<String, dynamic>;
            return DeviceModel.fromJson(data);
          }
        }
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DeviceEntity> createDevice() async {
    final deviceId = await _deviceInfoService.getDeviceId();
    final deviceModel = await _deviceInfoService.getDeviceModel();

    try {
      final response = await _apiClient.post(
        '/api/v1/devices',
        body: {
          'identifier': deviceId,
          'model': deviceModel,
        },
      );

      if (response.isSuccess) {
        final data = response.jsonBody['data'] as Map<String, dynamic>;
        return DeviceModel.fromJson(data);
      }

      throw Exception('Failed to create device: ${response.body}');
    } on InvalidCredentialException {
      final deviceId = await _deviceInfoService.getDeviceId(force: true);

      final response = await _apiClient.post(
        '/api/v1/devices',
        body: {
          'identifier': deviceId,
          'model': deviceModel,
        },
      );

      if (response.isSuccess) {
        final data = response.jsonBody['data'] as Map<String, dynamic>;
        return DeviceModel.fromJson(data);
      }

      throw Exception('Failed to create device: ${response.body}');
    }
  }

  @override
  Future<void> updateDevice({String? fcmToken}) async {
    final deviceId = await _deviceInfoService.getDeviceId();

    if (await _apiClient.isAuthenticated()) {
      await _updateAuthDevice(deviceId: deviceId, fcmToken: fcmToken);
    } else {
      await _updateUnAuthDevice(deviceId: deviceId, fcmToken: fcmToken);
    }
  }

  Future<void> _updateAuthDevice({
    required String deviceId,
    String? fcmToken,
  }) async {
    final response = await _apiClient.put(
      '/api/v1/devices/me',
      body: {
        'identifier': deviceId,
        'fcm_token': fcmToken,
      },
    );

    if (!response.isSuccess) {
      throw Exception('Failed to update authenticated device');
    }
  }

  Future<void> _updateUnAuthDevice({
    required String deviceId,
    String? fcmToken,
  }) async {
    final response = await _apiClient.put(
      '/api/v1/devices/by-identifier',
      body: {
        'identifier': deviceId,
        'fcm_token': fcmToken,
      },
    );

    if (!response.isSuccess) {
      throw Exception('Failed to update device');
    }
  }

  @override
  Future<void> linkDevice() async {
    final deviceId = await _deviceInfoService.getDeviceId();

    final response = await _apiClient.post(
      '/api/v1/devices/link',
      body: {
        'identifier': deviceId,
      },
    );

    if (response.statusCode == 404) {
      await createDevice();

      final response = await _apiClient.post(
        '/api/v1/devices/link',
        body: {
          'identifier': deviceId,
        },
      );

      if (response.isError) {
        throw Exception('Failed to link device to user account');
      }
      return;
    }

    if (response.isError) {
      throw Exception('Failed to link device to user account');
    }
  }

  @override
  Future<void> unlinkDevice(String deviceId) async {
    final response = await _apiClient.post(
      '/api/v1/devices/unlink',
      body: {
        'identifier': deviceId,
        'invalidate_token': true,
      },
    );

    if (response.isError) {
      throw Exception('Failed to unlink device from user account');
    }
  }

  @override
  Future<void> unlinkCurrentDevice() async {
    final deviceId = await _deviceInfoService.getDeviceId();

    final response = await _apiClient.post(
      '/api/v1/devices/unlink',
      body: {
        'identifier': deviceId,
      },
    );

    if (response.isError) {
      throw Exception('Failed to unlink device from user account');
    }
  }
}
