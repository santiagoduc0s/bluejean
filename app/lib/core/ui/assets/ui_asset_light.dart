import 'package:lune/core/ui/assets/assets.dart';
import 'package:lune/gen/assets.gen.dart';

/// The light theme implementation of [UIAsset].
class UIAssetLight implements UIAsset {
  UIAssetLight._singleton();

  /// Singleton instance of [UIAssetLight].
  static final UIAssetLight instance = UIAssetLight._singleton();

  @override
  String get logo => Assets.light.images.logo.path;

  @override
  String get publicOnboardPage1 => Assets.light.images.publicOnboardPage1.path;
}
