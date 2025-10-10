import 'package:go_router/go_router.dart';
import 'package:lune/ui/profile/notifiers/notifiers.dart';
import 'package:lune/ui/profile/views/views.dart';
import 'package:provider/provider.dart';

class ProfileScreen {
  const ProfileScreen();

  static const path = '/profile';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create:
            (context) => ProfileNotifier(
              updateCurrentUserUsecase: context.read(),
              authNotifier: context.read(),
            )..initialize(),
        child: const ProfilePage(),
      );
    },
    routes: routes,
  );
}
