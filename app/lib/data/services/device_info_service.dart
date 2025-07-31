import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:lune/data/services/services.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoService {
  DeviceInfoService({
    DeviceInfoPlugin? deviceInfo,
    LocalStorageService? localStorageService,
  })  : _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
        _localStorageService = localStorageService ?? LocalStorageService();

  final DeviceInfoPlugin _deviceInfo;
  final LocalStorageService _localStorageService;

  Future<String> getDeviceId({bool force = false}) async {
    final box = await _localStorageService.box();
    var existingId = box.get('deviceId') as String?;

    if (force || existingId == null) {
      existingId = const Uuid().v4();
      await box.put('deviceId', existingId);
    }

    return existingId;
  }

  Future<String> getDeviceModel() async {
    if (kIsWeb) {
      final webInfo = await _deviceInfo.webBrowserInfo;
      return webInfo.browserName.name;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.modelName;

      case TargetPlatform.android:
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.model;

      case TargetPlatform.windows:
        final windowsInfo = await _deviceInfo.windowsInfo;
        return windowsInfo.computerName;

      case TargetPlatform.macOS:
        final macOsInfo = await _deviceInfo.macOsInfo;
        return macOsInfo.model;

      case TargetPlatform.linux:
        final linuxInfo = await _deviceInfo.linuxInfo;
        return linuxInfo.name;

      case TargetPlatform.fuchsia:
        throw UnsupportedError('Fuchsia platform not supported');
    }
  }
}
