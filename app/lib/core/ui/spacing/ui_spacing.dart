import 'package:flutter/widgets.dart';

/// Extension on [double] to provide spacing constants.
extension UISpacingX on num {
  /// Spacing multiplier for 1x.
  double get space => (this * UISpacing.spaceUnit).toDouble();

  SizedBox get spaceX => SizedBox(width: space);
  SizedBox get spaceY => SizedBox(height: space);
}

/// A class that defines the spacing constants used in the UI.
abstract class UISpacing {
  /// Spacing constants.
  static const spaceUnit = 4;

  /// Spacing infinity.
  static const infinity = double.infinity;

  /// Spacing zero.
  static const zero = 0.0;
}
