import 'package:flutter/material.dart';
import 'package:lune/core/ui/assets/assets.dart';
import 'package:lune/core/ui/icons/icons.dart';
import 'package:lune/core/ui/spacing/spacing.dart';

/// The dark theme implementation of [UIIcon].
class UIIconDark extends UIIcon {
  UIIconDark._singleton();

  /// Singleton instance of [UIIconDark].
  static final UIIconDark instance = UIIconDark._singleton();

  final UIAsset _assets = UIAssetDark.instance;

  @override
  Widget logo({double? size}) {
    return Image.asset(
      _assets.logo,
      height: size ?? 10.space,
      width: size ?? 10.space,
    );
  }
}
