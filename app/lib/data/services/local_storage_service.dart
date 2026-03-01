import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences? _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const _keyTheme = 'themeMode';
  static const _keyScale = 'textScaler';
  static const _keyLocale = 'locale';
  static const _keyPublicOnboard = 'publicOnboard';
  static const _keyAccessToken = 'accessToken';
  static const _keyHomeTutorialShown = 'homeTutorialShown';
  static const _keyDeviceId = 'deviceId';

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> _setOrRemoveString(String key, String? value) async {
    final prefs = await _getPrefs();
    if (value != null) {
      await prefs.setString(key, value);
    } else {
      await prefs.remove(key);
    }
  }

  // Theme

  Future<String?> getThemeModeKey() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyTheme);
  }

  Future<void> setThemeModeKey(String? key) async {
    await _setOrRemoveString(_keyTheme, key);
  }

  // Text Scale

  Future<double?> getTextScaler() async {
    final prefs = await _getPrefs();
    return prefs.getDouble(_keyScale);
  }

  Future<void> setTextScaler(double scaler) async {
    final prefs = await _getPrefs();
    await prefs.setDouble(_keyScale, scaler);
  }

  // Locale

  Future<String?> getLocaleCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyLocale);
  }

  Future<void> setLocaleCode(String? code) async {
    await _setOrRemoveString(_keyLocale, code);
  }

  // Public Onboard

  Future<PublicOnboardStatus> getPOStatus() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_keyPublicOnboard);
    return raw == PublicOnboardStatus.seen.name
        ? PublicOnboardStatus.seen
        : PublicOnboardStatus.unseen;
  }

  Future<void> setPOStatus(PublicOnboardStatus status) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyPublicOnboard, status.name);
  }

  // Access Token (secure storage)

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _keyAccessToken);
  }

  Future<void> setAccessToken(String? token) async {
    if (token != null) {
      await _secureStorage.write(key: _keyAccessToken, value: token);
    } else {
      await _secureStorage.delete(key: _keyAccessToken);
    }
  }

  // Home Tutorial

  Future<bool> getHomeTutorialShown() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_keyHomeTutorialShown) ?? false;
  }

  Future<void> setHomeTutorialShown(bool shown) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyHomeTutorialShown, shown);
  }

  // Device ID

  Future<String?> getDeviceId() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyDeviceId);
  }

  Future<void> setDeviceId(String deviceId) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyDeviceId, deviceId);
  }
}
