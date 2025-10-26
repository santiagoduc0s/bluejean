import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/home/home.dart';
import 'package:lune/ui/public_onboard/public_onboard.dart';
import 'package:lune/ui/ui.dart';

class SplashNotifier extends ChangeNotifier {
  SplashNotifier({
    required this.authRepository,
    required this.localStorageService,
    required this.router,
  });

  final AuthRepository authRepository;
  final LocalStorageService localStorageService;
  final CustomRouter router;

  Future<void> initialize() async {
    await Future.delayed(3800.ms, () {}); // Custom animation

    final e = await localStorageService.getPOStatus();
    if (e == PublicOnboardStatus.unseen) {
      return router.goNamed(PublicOnboardScreen.path);
    }

    router.goNamed(TrucoGameScreen.path);
  }
}
