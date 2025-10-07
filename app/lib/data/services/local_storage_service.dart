import 'package:lune/domain/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences? _prefs;

  static const _keyTheme = 'themeMode';
  static const _keyScale = 'textScaler';
  static const _keyLocale = 'locale';
  static const _publicOnboard = 'publicOnboard';
  static const _accessToken = 'accessToken';
  static const _homeTutorialShown = 'homeTutorialShown';

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<String?> getThemeModeKey() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyTheme);
  }

  Future<double?> getTextScaler() async {
    final prefs = await _getPrefs();
    return prefs.getDouble(_keyScale);
  }

  Future<String?> getLocaleCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyLocale);
  }

  Future<void> setThemeModeKey(String key) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyTheme, key);
  }

  Future<void> setTextScaler(double scaler) async {
    final prefs = await _getPrefs();
    await prefs.setDouble(_keyScale, scaler);
  }

  Future<void> setLocaleCode(String? code) async {
    final prefs = await _getPrefs();
    if (code != null) {
      await prefs.setString(_keyLocale, code);
    } else {
      await prefs.remove(_keyLocale);
    }
  }

  Future<PublicOnboardStatus> getPOStatus() async {
    final prefs = await _getPrefs();
    final publicOnboardStatusRaw = prefs.getString(_publicOnboard);

    if (publicOnboardStatusRaw == 'seen') {
      return PublicOnboardStatus.seen;
    } else if (publicOnboardStatusRaw == 'unseen') {
      return PublicOnboardStatus.unseen;
    } else {
      return PublicOnboardStatus.unseen;
    }
  }

  Future<void> setPOStatus(PublicOnboardStatus status) async {
    final prefs = await _getPrefs();
    switch (status) {
      case PublicOnboardStatus.seen:
        await prefs.setString(_publicOnboard, 'seen');
      case PublicOnboardStatus.unseen:
        await prefs.setString(_publicOnboard, 'unseen');
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_accessToken);
  }

  Future<void> setAccessToken(String? token) async {
    final prefs = await _getPrefs();
    if (token != null) {
      await prefs.setString(_accessToken, token);
    } else {
      await prefs.remove(_accessToken);
    }
  }

  Future<bool> getHomeTutorialShown() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_homeTutorialShown) ?? false;
  }

  Future<void> setHomeTutorialShown(bool shown) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_homeTutorialShown, shown);
  }

  Future<String?> getDeviceId() async {
    final prefs = await _getPrefs();
    return prefs.getString('deviceId');
  }

  Future<void> setDeviceId(String deviceId) async {
    final prefs = await _getPrefs();
    await prefs.setString('deviceId', deviceId);
  }
}
