import 'package:flutter/material.dart';
import 'package:lune/gen/assets.gen.dart';

class AppAssets {
  AppAssets({required this.brightness});

  final Brightness brightness;

  bool get _isDark => brightness == Brightness.dark;

  String get logo =>
      _isDark ? Assets.dark.images.logo.path : Assets.light.images.logo.path;

  String get downloadAndroid =>
      _isDark
          ? Assets.dark.icons.downloadAndroid
          : Assets.light.icons.downloadAndroid;

  String get downloadApple =>
      _isDark
          ? Assets.dark.icons.downloadApple
          : Assets.light.icons.downloadApple;
}
