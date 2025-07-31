import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Abstract class for UIColor.
class HctColor {
  /// Generates a Material 3 color palette based on the provided HCT color.
  static Map<int, Color> generateMaterial3TonesHct(int baseColorInt) {
    final baseColor = Hct.fromInt(baseColorInt);
    final baseHue = baseColor.hue;
    final baseChroma = baseColor.chroma;

    final colorMap = <int, Color>{};

    for (var tone = 0; tone <= 100; tone++) {
      final hctToned = Hct.from(baseHue, baseChroma, tone.toDouble());
      colorMap[tone] = Color(hctToned.toInt());
    }

    return colorMap;
  }
}
