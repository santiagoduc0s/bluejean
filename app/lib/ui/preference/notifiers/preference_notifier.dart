import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class PreferenceNotifier extends ChangeNotifier {
  PreferenceNotifier({
    required PreferenceRepository userPreferenceRepository,
  }) : _userPreferenceRepository = userPreferenceRepository;

  final PreferenceRepository _userPreferenceRepository;

  PreferenceEntity? preference;

  void initialize(PreferenceEntity preference) {
    this.preference = preference;
    notifyListeners();
  }

  Future<void> setTheme(String? theme) async {
    preference = preference!.copyWith(theme: NullableParameter(theme));
    notifyListeners();

    unawaited(
      _userPreferenceRepository.updatePreference(
        theme: NullableParameter(theme),
      ),
    );
  }

  Future<void> setTextScaler(double textScaler) async {
    preference = preference!.copyWith(textScaler: textScaler);
    notifyListeners();

    unawaited(
      _userPreferenceRepository.updatePreference(
        textScaler: NullableParameter(textScaler),
      ),
    );
  }

  Future<void> setLanguage(String? language) async {
    preference = preference!.copyWith(
      language: NullableParameter(language),
    );

    notifyListeners();

    unawaited(
      _userPreferenceRepository.updatePreference(
        language: NullableParameter(language),
      ),
    );
  }
}
