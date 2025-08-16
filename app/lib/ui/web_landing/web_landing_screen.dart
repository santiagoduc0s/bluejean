import 'package:go_router/go_router.dart';
import 'package:lune/ui/web_landing/widgets/widgets.dart';

class WebLandingScreen {
  const WebLandingScreen();

  static const path = '/';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) {
      return const WebLandingPage();
    },
    routes: routes,
  );
}
