import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  Box<dynamic>? _box;

  static const _boxName = 'localStorage';
  static const _keyTheme = 'themeMode';
  static const _keyScale = 'textScaler';
  static const _keyLocale = 'locale';
  static const _publicOnboard = 'publicOnboard';
  static const _accessToken = 'accessToken';

  Future<Box<dynamic>> box() async {
    if (_box == null) {
      await initialize();
    }
    return _box!;
  }

  Future<void> initialize() async {
    if (kIsWeb) {
      Hive.init('');
    } else {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }

    _box = await Hive.openBox(_boxName);
  }

  Future<String?> getThemeModeKey() async {
    return (await box()).get(_keyTheme) as String?;
  }

  Future<double?> getTextScaler() async {
    return (await box()).get(_keyScale) as double?;
  }

  Future<String?> getLocaleCode() async {
    return (await box()).get(_keyLocale) as String?;
  }

  Future<void> setThemeModeKey(String key) async {
    return (await box()).put(_keyTheme, key);
  }

  Future<void> setTextScaler(double scaler) async {
    return (await box()).put(_keyScale, scaler);
  }

  Future<void> setLocaleCode(String? code) async {
    if (code != null) {
      return (await box()).put(_keyLocale, code);
    } else {
      return (await box()).delete(_keyLocale);
    }
  }

  Future<PublicOnboardStatus> getStatus() async {
    final publicOnboardStatusRaw = (await box()).get(_publicOnboard) as String?;

    if (publicOnboardStatusRaw == 'seen') {
      return PublicOnboardStatus.seen;
    } else if (publicOnboardStatusRaw == 'unseen') {
      return PublicOnboardStatus.unseen;
    } else {
      return PublicOnboardStatus.unseen;
    }
  }

  Future<void> setStatus(PublicOnboardStatus status) async {
    switch (status) {
      case PublicOnboardStatus.seen:
        await (await box()).put(_publicOnboard, 'seen');
      case PublicOnboardStatus.unseen:
        await (await box()).put(_publicOnboard, 'unseen');
    }
  }

  Future<String?> getAccessToken() async {
    return (await box()).get(_accessToken) as String?;
  }

  Future<void> setAccessToken(String? token) async {
    if (token != null) {
      return (await box()).put(_accessToken, token);
    } else {
      return (await box()).delete(_accessToken);
    }
  }
}
