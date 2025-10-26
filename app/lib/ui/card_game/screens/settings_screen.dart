import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:lune/ui/card_game/components/menu_button.dart';
import 'package:lune/ui/card_game/game_constants.dart';
import 'package:lune/ui/card_game/truco_game_screen.dart';

class GameSettingsScreen extends Component with HasGameReference<TrucoGame> {
  late final SettingsContent content;

  static const path = 'settings';

  @override
  Future<void> onLoad() async {
    content = SettingsContent();
    add(content);
  }

  @override
  void onMount() {
    super.onMount();

    content.scale = Vector2.all(0.5);
    content.opacity = 0;

    content
      ..add(
        ScaleEffect.to(
          Vector2.all(1),
          EffectController(duration: 0.4, curve: Curves.easeOutBack),
        ),
      )
      ..add(OpacityEffect.fadeIn(EffectController(duration: 0.3)));
  }
}

class SettingsContent extends PositionComponent
    with HasGameReference<TrucoGame>, HasPaint {
  SettingsContent() : super(scale: Vector2.all(0.5));

  @override
  Future<void> onLoad() async {
    final background = RectangleComponent(
      size: Vector2(GameConstants.cameraWidth, GameConstants.cameraHeight),
      paint: Paint()..color = const Color(0xFF3d4a5e),
      position: Vector2(50, 30),
    );

    final title = TextComponent(
      text: 'SETTINGS',
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 48),
      ),
      position: Vector2(400, 100),
      anchor: Anchor.center,
    );

    final backButton = MenuButton(
      text: 'BACK',
      position: Vector2(400, 500),
      onTap: () => game.goBack(),
    );

    add(background);
    add(title);
    add(backButton);
  }
}
