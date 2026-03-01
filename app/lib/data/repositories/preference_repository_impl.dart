import 'package:lune/data/services/services.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';

class PreferenceRepositoryImpl implements PreferenceRepository {
  PreferenceRepositoryImpl({required LocalStorageService localStorageService})
    : _localStorageService = localStorageService;

  final LocalStorageService _localStorageService;

  @override
  Future<String?> getThemeModeKey() => _localStorageService.getThemeModeKey();

  @override
  Future<void> setThemeModeKey(String? key) =>
      _localStorageService.setThemeModeKey(key);

  @override
  Future<double?> getTextScaler() => _localStorageService.getTextScaler();

  @override
  Future<void> setTextScaler(double scaler) =>
      _localStorageService.setTextScaler(scaler);

  @override
  Future<String?> getLocaleCode() => _localStorageService.getLocaleCode();

  @override
  Future<void> setLocaleCode(String? code) =>
      _localStorageService.setLocaleCode(code);

  @override
  Future<PublicOnboardStatus> getPOStatus() =>
      _localStorageService.getPOStatus();

  @override
  Future<void> setPOStatus(PublicOnboardStatus status) =>
      _localStorageService.setPOStatus(status);
}
