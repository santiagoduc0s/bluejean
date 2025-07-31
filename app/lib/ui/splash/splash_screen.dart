import 'package:go_router/go_router.dart';
import 'package:lune/core/ui/animations/animations.dart';
import 'package:lune/ui/splash/notifiers/notifiers.dart';
import 'package:lune/ui/splash/widgets/splash_page.dart';
import 'package:provider/provider.dart';

class SplashScreen {
  const SplashScreen();

  static const path = '/splash';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: path,
      name: path,
      pageBuilder: (context, state) {
        return RouteAnimation.noAnimationTransition(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            lazy: false,
            create: (context) => SplashNotifier(
              authRepository: context.read(),
              getPublicOnboardStatusUseCase: context.read(),
              router: context.read(),
            )..initialize(),
            child: const SplashPage(),
          ),
        );
      },
      routes: routes,
    );
  }
}
