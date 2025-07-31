import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/domain/usecases/public_onboard/public_onboard.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/home/home.dart';
import 'package:lune/ui/public_onboard/public_onboard.dart';

class SplashNotifier extends ChangeNotifier {
  SplashNotifier({
    required this.authRepository,
    required this.getPublicOnboardStatusUseCase,
    required this.router,
  });

  final AuthRepository authRepository;
  final GetPublicOnboardStatusUseCase getPublicOnboardStatusUseCase;
  final CustomRouter router;

  Future<void> initialize() async {
    await Future.delayed(2600.ms, () {}); // Custom animation

    final e = await getPublicOnboardStatusUseCase.call();
    if (e == PublicOnboardStatus.unseen) {
      return router.goNamed(PublicOnboardScreen.path);
    }

    // if (await authRepository.isAuthenticated()) {
    //   return router.goNamed(HomeScreen.path);
    // } else {
    //   return router.goNamed(SignInScreen.path);
    // }

    router.goNamed(HomeScreen.path);
  }
}
