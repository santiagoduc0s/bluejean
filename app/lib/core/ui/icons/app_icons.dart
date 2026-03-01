import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lune/core/ui/assets/app_assets.dart';
import 'package:lune/core/ui/spacing/ui_spacing.dart';

class AppIcons {
  AppIcons({required this.assets});

  final AppAssets assets;

  Widget logo({double? size}) {
    return Image.asset(
      assets.logo,
      height: size ?? 10.space,
      width: size ?? 10.space,
    );
  }

  Widget downloadAndroid({double? width}) {
    return SvgPicture.asset(assets.downloadAndroid, width: width ?? 10.space);
  }

  Widget downloadIOS({double? width}) {
    return SvgPicture.asset(assets.downloadApple, width: width ?? 10.space);
  }
}
