import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/models/models.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/preference_repository.dart';

class PreferenceRepositoryImpl implements PreferenceRepository {
  PreferenceRepositoryImpl({
    required DeviceInfoService deviceInfoService,
    required ApiClient apiClient,
  })  : _deviceInfoService = deviceInfoService,
        _apiClient = apiClient;

  final DeviceInfoService _deviceInfoService;
  final ApiClient _apiClient;

  @override
  Future<PreferenceEntity> getCurrentPreference() async {
    if (await _apiClient.isAuthenticated()) {
      return _getCurrentAuthPreference();
    } else {
      return _getCurrentDevicePreference();
    }
  }

  Future<PreferenceEntity> _getCurrentDevicePreference() async {
    final deviceId = await _deviceInfoService.getDeviceId();

    final response = await _apiClient.get(
      '/api/v1/preferences/by-device',
      queryParameters: {
        'identifier': deviceId,
      },
    );

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      return PreferenceModel.fromJson(data);
    } else {
      throw Exception('Failed to get device preference');
    }
  }

  Future<PreferenceEntity> _getCurrentAuthPreference() async {
    final response = await _apiClient.get('/api/v1/preferences/me');

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      return PreferenceModel.fromJson(data);
    } else {
      throw Exception('Failed to get authenticated user preference');
    }
  }

  @override
  Future<PreferenceEntity> updatePreference({
    NullableParameter<String?>? theme,
    NullableParameter<String?>? language,
    NullableParameter<double?>? textScaler,
    bool? notificationsAreEnabled,
  }) async {
    if (await _apiClient.isAuthenticated()) {
      return _updateAuthPreference(
        theme: theme,
        language: language,
        textScaler: textScaler,
        notificationsAreEnabled: notificationsAreEnabled,
      );
    } else {
      return _updateDevicePreference(
        theme: theme,
        language: language,
        textScaler: textScaler,
        notificationsAreEnabled: notificationsAreEnabled,
      );
    }
  }

  Future<PreferenceEntity> _updateDevicePreference({
    NullableParameter<String?>? theme,
    NullableParameter<String?>? language,
    NullableParameter<double?>? textScaler,
    bool? notificationsAreEnabled,
  }) async {
    final deviceId = await _deviceInfoService.getDeviceId();

    final response = await _apiClient.put(
      '/api/v1/preferences/by-device',
      body: {
        'identifier': deviceId,
        if (theme != null) 'theme': theme.value,
        if (language != null) 'language': language.value,
        if (textScaler != null) 'text_scaler': textScaler.value,
        if (notificationsAreEnabled != null)
          'notifications_are_enabled': notificationsAreEnabled,
      },
    );

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      return PreferenceModel.fromJson(data);
    } else {
      throw Exception('Failed to update device preference');
    }
  }

  Future<PreferenceEntity> _updateAuthPreference({
    NullableParameter<String?>? theme,
    NullableParameter<String?>? language,
    NullableParameter<double?>? textScaler,
    bool? notificationsAreEnabled,
  }) async {
    final response = await _apiClient.put(
      '/api/v1/preferences/me',
      body: {
        if (theme != null) 'theme': theme.value,
        if (language != null) 'language': language.value,
        if (textScaler != null) 'text_scaler': textScaler.value,
        if (notificationsAreEnabled != null)
          'notifications_are_enabled': notificationsAreEnabled,
      },
    );

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      return PreferenceModel.fromJson(data);
    } else {
      throw Exception('Failed to update authenticated user preference');
    }
  }
}
