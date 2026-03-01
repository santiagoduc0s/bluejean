import 'package:flutter/material.dart';
import 'package:lune/data/services/services.dart';

class PreferenceNotifier extends ChangeNotifier {
  PreferenceNotifier({required LocalStorageService localStorageService})
    : _localStorageService = localStorageService;

  final LocalStorageService _localStorageService;

  String? theme;
  String? language;
  double? textScaler;

  Future<void> initialize() async {
    theme = await _localStorageService.getThemeModeKey();
    language = await _localStorageService.getLocaleCode();
    textScaler = await _localStorageService.getTextScaler();
    notifyListeners();
  }

  Future<void> setTheme(String? value) async {
    theme = value;
    notifyListeners();
    await _localStorageService.setThemeModeKey(value);
  }

  Future<void> setTextScaler(double value) async {
    textScaler = value;
    notifyListeners();
    await _localStorageService.setTextScaler(value);
  }

  Future<void> setLanguage(String? value) async {
    language = value;
    notifyListeners();
    await _localStorageService.setLocaleCode(value);
  }
}
