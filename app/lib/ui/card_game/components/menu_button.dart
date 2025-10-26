import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class MenuButton extends PositionComponent with TapCallbacks {
  MenuButton({
    required this.text,
    required Vector2 position,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(200, 60),
          anchor: Anchor.center,
        );

  final String text;
  final VoidCallback onTap;

  @override
  Future<void> onLoad() async {
    final rect = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.orange,
    );
    add(rect);

    final textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
      position: size / 2,
      anchor: Anchor.center,
    );
    add(textComponent);
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap();
  }
}
