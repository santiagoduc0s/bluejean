import 'package:equatable/equatable.dart';
import 'package:lune/core/utils/utils.dart';

class PreferenceEntity extends Equatable {
  const PreferenceEntity({
    required this.id,
    required this.notificationsAreEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.theme,
    required this.language,
    required this.textScaler,
  });

  final int id;
  final String? theme;
  final String? language;
  final double? textScaler;
  final bool notificationsAreEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  PreferenceEntity copyWith({
    int? id,
    NullableParameter<String?>? theme,
    NullableParameter<String?>? language,
    double? textScaler,
    bool? notificationsAreEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PreferenceEntity(
      id: id ?? this.id,
      theme: theme == null ? this.theme : theme.value,
      language: language == null ? this.language : language.value,
      textScaler: textScaler ?? this.textScaler,
      notificationsAreEnabled:
          notificationsAreEnabled ?? this.notificationsAreEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      theme,
      language,
      textScaler,
      notificationsAreEnabled,
      createdAt,
      updatedAt,
    ];
  }
}
