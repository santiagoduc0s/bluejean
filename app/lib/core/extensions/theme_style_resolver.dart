import 'package:flutter/material.dart';
import 'package:lune/core/ui/assets/app_assets.dart';
import 'package:lune/core/ui/icons/app_icons.dart';
import 'package:lune/core/ui/styles/buttons/app_button_styles.dart';
import 'package:lune/core/ui/styles/inputs/app_input_styles.dart';

extension ThemeStyleResolver on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textStyles => Theme.of(this).textTheme;

  AppButtonStyles get buttonStyles =>
      AppButtonStyles(colorScheme: colors, textTheme: textStyles);

  AppInputStyles get inputStyles => AppInputStyles(colorScheme: colors);

  AppAssets get assets => AppAssets(brightness: Theme.of(this).brightness);

  AppIcons get icons => AppIcons(assets: assets);
}
