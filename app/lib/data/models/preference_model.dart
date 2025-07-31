import 'package:lune/domain/entities/entities.dart';

class PreferenceModel extends PreferenceEntity {
  const PreferenceModel({
    required super.id,
    required super.notificationsAreEnabled,
    required super.createdAt,
    required super.updatedAt,
    super.theme,
    super.language,
    super.textScaler,
  });

  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      id: json['id'] as int,
      notificationsAreEnabled: json['notifications_are_enabled'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      theme: json['theme'] as String?,
      language: json['language'] as String?,
      textScaler: (json['text_scaler'] as num?)?.toDouble(),
    );
  }
}
