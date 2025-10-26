import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:lune/ui/card_game/truco_game_screen.dart';
import 'package:lune/ui/card_game/components/menu_button.dart';
import 'package:lune/ui/card_game/game_constants.dart';

class MenuScreen extends Component with HasGameReference<TrucoGame> {
  late MenuContent content;

  static const path = 'menu';

  @override
  Future<void> onLoad() async {
    content = MenuContent();
    add(content);
  }

  @override
  void onMount() {
    super.onMount();

    content.opacity = 0;

    content.add(OpacityEffect.fadeIn(EffectController(duration: 0.5)));
  }
}

class MenuContent extends PositionComponent
    with HasGameReference<TrucoGame>, HasPaint {
  @override
  Future<void> onLoad() async {
    final background = RectangleComponent(
      size: Vector2(GameConstants.cameraWidth, GameConstants.cameraHeight),
      paint: Paint()..color = const Color.fromARGB(255, 155, 107, 147),
      position: Vector2(0, 0),
    );

    final title = TextComponent(
      text: 'TRUCO URUGUAYO',
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 48),
      ),
      position: Vector2(300, 100),

    );

    final startButton = MenuButton(
      text: 'START',
      position: Vector2(400, 300),
      onTap: () => game.showMatch(),
    );

    final settingsButton = MenuButton(
      text: 'SETTINGS',
      position: Vector2(400, 400),
      onTap: () => game.showSettings(),
    );

    add(background);
    add(title);
    add(startButton);
    add(settingsButton);
  }
}
