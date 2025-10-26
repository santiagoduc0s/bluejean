import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';
import 'package:lune/ui/card_game/game_constants.dart';
import 'package:lune/ui/card_game/screens/match_screen.dart';
import 'package:lune/ui/card_game/screens/menu_screen.dart';
import 'package:lune/ui/card_game/screens/settings_screen.dart';

class TrucoGameScreen {
  const TrucoGameScreen();

  static const path = '/card-game';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) => const CardGamePage(),
    routes: routes,
  );
}

class CardGamePage extends StatelessWidget {
  const CardGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    const aspectRatio = GameConstants.cameraWidth / GameConstants.cameraHeight;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: FittedBox(
            child: SizedBox(
              width: GameConstants.cameraWidth,
              height: GameConstants.cameraHeight,
              child: GameWidget(game: TrucoGame()),
            ),
          ),
        ),
      ),
    );
  }
}

class TrucoGame extends FlameGame {
  late RouterComponent router;

  @override
  Future<void> onLoad() async {
    camera = CameraComponent.withFixedResolution(
      world: world,
      width: GameConstants.cameraWidth,
      height: GameConstants.cameraHeight,
    )..viewport.anchor = Anchor.topLeft;

    final border = RectangleComponent(
      size: Vector2(GameConstants.cameraWidth, GameConstants.cameraHeight),
      paint:
          Paint()
            ..color = const Color(0xFF000000)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
    );

    router = RouterComponent(
      routes: {
        MenuScreen.path: Route(MenuScreen.new),
        MatchScreen.path: Route(MatchScreen.new),
        GameSettingsScreen.path: Route(GameSettingsScreen.new),
      },
      initialRoute: MenuScreen.path,
    );

    await addAll([border, router]);
  }

  void showMenu() => router.pushNamed(MenuScreen.path);
  void showMatch() => router.pushNamed(MatchScreen.path);
  void showSettings() => router.pushNamed(GameSettingsScreen.path);
  void goBack() => router.pop();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 255, 30, 0);
}
