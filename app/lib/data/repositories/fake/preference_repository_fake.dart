import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';

class PreferenceRepositoryFake implements PreferenceRepository {
  String? _themeModeKey;
  double? _textScaler;
  String? _localeCode;
  PublicOnboardStatus _poStatus = PublicOnboardStatus.unseen;

  @override
  Future<String?> getThemeModeKey() async => _themeModeKey;

  @override
  Future<void> setThemeModeKey(String? key) async => _themeModeKey = key;

  @override
  Future<double?> getTextScaler() async => _textScaler;

  @override
  Future<void> setTextScaler(double scaler) async => _textScaler = scaler;

  @override
  Future<String?> getLocaleCode() async => _localeCode;

  @override
  Future<void> setLocaleCode(String? code) async => _localeCode = code;

  @override
  Future<PublicOnboardStatus> getPOStatus() async => _poStatus;

  @override
  Future<void> setPOStatus(PublicOnboardStatus status) async =>
      _poStatus = status;
}
