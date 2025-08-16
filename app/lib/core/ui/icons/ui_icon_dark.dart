import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  Widget downloadAndroid({double? width}) {
    return SvgPicture.asset(_assets.downloadAndroid, width: width ?? 10.space);
  }

  @override
  Widget downloadIOS({double? width}) {
    return SvgPicture.asset(_assets.downloadApple, width: width ?? 10.space);
  }
}
