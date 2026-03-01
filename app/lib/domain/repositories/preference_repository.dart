import 'package:lune/domain/enums/enums.dart';

abstract class PreferenceRepository {
  Future<String?> getThemeModeKey();
  Future<void> setThemeModeKey(String? key);
  Future<double?> getTextScaler();
  Future<void> setTextScaler(double scaler);
  Future<String?> getLocaleCode();
  Future<void> setLocaleCode(String? code);
  Future<PublicOnboardStatus> getPOStatus();
  Future<void> setPOStatus(PublicOnboardStatus status);
}
