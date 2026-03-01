import 'package:flutter/material.dart';
import 'package:lune/domain/repositories/repositories.dart';

class PreferenceNotifier extends ChangeNotifier {
  PreferenceNotifier({required PreferenceRepository preferenceRepository})
    : _preferenceRepository = preferenceRepository;

  final PreferenceRepository _preferenceRepository;

  String? theme;
  String? language;
  double? textScaler;

  Future<void> initialize() async {
    theme = await _preferenceRepository.getThemeModeKey();
    language = await _preferenceRepository.getLocaleCode();
    textScaler = await _preferenceRepository.getTextScaler();
    notifyListeners();
  }

  Future<void> setTheme(String? value) async {
    theme = value;
    notifyListeners();
    await _preferenceRepository.setThemeModeKey(value);
  }

  Future<void> setTextScaler(double value) async {
    textScaler = value;
    notifyListeners();
    await _preferenceRepository.setTextScaler(value);
  }

  Future<void> setLanguage(String? value) async {
    language = value;
    notifyListeners();
    await _preferenceRepository.setLocaleCode(value);
  }
}
