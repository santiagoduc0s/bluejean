import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';

abstract class PreferenceRepository {
  Future<PreferenceEntity> getCurrentPreference();

  Future<PreferenceEntity> updatePreference({
    NullableParameter<String?>? theme,
    NullableParameter<String?>? language,
    NullableParameter<double?>? textScaler,
    bool? notificationsAreEnabled,
  });
}
