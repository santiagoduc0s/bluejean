import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:lune/ui/card_game/components/card.dart';
import 'package:lune/ui/card_game/components/menu_button.dart';
import 'package:lune/ui/card_game/game_constants.dart';
import 'package:lune/ui/card_game/truco_game_screen.dart';

class MatchScreen extends Component with HasGameReference<TrucoGame> {
  late MatchContent content;

  static const path = 'match';

  @override
  Future<void> onLoad() async {
    content = MatchContent();
    add(content);
  }

  @override
  void onMount() {
    super.onMount();

    content.position = Vector2(GameConstants.cameraWidth, 0);
    content.opacity = 0;

    content
      ..add(
        MoveEffect.to(
          Vector2(0, 0),
          EffectController(duration: 0.4, curve: Curves.easeOut),
        ),
      )
      ..add(OpacityEffect.fadeIn(EffectController(duration: 0.3)));
  }
}

class MatchContent extends PositionComponent
    with HasGameReference<TrucoGame>, HasPaint {
  MatchContent()
      : super(
          size: Vector2(GameConstants.cameraWidth, GameConstants.cameraHeight),
        );

  @override
  Future<void> onLoad() async {
    final background = RectangleComponent(
      position: Vector2(0, 0),
      size: Vector2(
        GameConstants.cameraWidth / 3,
        GameConstants.cameraHeight / 3,
      ),
      paint: Paint()..color = const Color(0xFF2d4a3e),
    );

    final title = TextComponent(
      text: 'MATCH IN PROGRESS',
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 48),
      ),
      anchor: Anchor.center,
      position: size / 2,
    );

    final backButton = MenuButton(
      text: 'BACK',
      position: Vector2(400, 500),
      onTap: () => game.showMenu(),
    );

    final exampleCard = CardComponent.fromData(
      const CardData(palo: CardSuit.espada, valor: 1),
      size: CardComponent.spriteSize / 3,
      position: size / 2,
      anchor: Anchor.center,
    );

    add(background);
    add(title);
    add(backButton);
    add(exampleCard);
  }
}
