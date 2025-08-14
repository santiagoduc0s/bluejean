// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsDarkGen {
  const $AssetsDarkGen();

  /// Directory path: assets/dark/icons
  $AssetsDarkIconsGen get icons => const $AssetsDarkIconsGen();

  /// Directory path: assets/dark/images
  $AssetsDarkImagesGen get images => const $AssetsDarkImagesGen();
}

class $AssetsFilesGen {
  const $AssetsFilesGen();

  /// File path: assets/files/privacy_policy.md
  String get privacyPolicy => 'assets/files/privacy_policy.md';

  /// File path: assets/files/terms_conditions.md
  String get termsConditions => 'assets/files/terms_conditions.md';

  /// List of all assets
  List<String> get values => [privacyPolicy, termsConditions];
}

class $AssetsLightGen {
  const $AssetsLightGen();

  /// Directory path: assets/light/icons
  $AssetsLightIconsGen get icons => const $AssetsLightIconsGen();

  /// Directory path: assets/light/images
  $AssetsLightImagesGen get images => const $AssetsLightImagesGen();
}

class $AssetsDarkIconsGen {
  const $AssetsDarkIconsGen();

  /// File path: assets/dark/icons/logo.svg
  String get logo => 'assets/dark/icons/logo.svg';

  /// List of all assets
  List<String> get values => [logo];
}

class $AssetsDarkImagesGen {
  const $AssetsDarkImagesGen();

  /// File path: assets/dark/images/.gitignore
  String get aGitignore => 'assets/dark/images/.gitignore';

  /// File path: assets/dark/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/dark/images/logo.png');

  /// List of all assets
  List<dynamic> get values => [aGitignore, logo];
}

class $AssetsLightIconsGen {
  const $AssetsLightIconsGen();

  /// File path: assets/light/icons/logo.svg
  String get logo => 'assets/light/icons/logo.svg';

  /// List of all assets
  List<String> get values => [logo];
}

class $AssetsLightImagesGen {
  const $AssetsLightImagesGen();

  /// File path: assets/light/images/.gitignore
  String get aGitignore => 'assets/light/images/.gitignore';

  /// File path: assets/light/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/light/images/logo.png');

  /// List of all assets
  List<dynamic> get values => [aGitignore, logo];
}

class Assets {
  const Assets._();

  static const $AssetsDarkGen dark = $AssetsDarkGen();
  static const $AssetsFilesGen files = $AssetsFilesGen();
  static const $AssetsLightGen light = $AssetsLightGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
