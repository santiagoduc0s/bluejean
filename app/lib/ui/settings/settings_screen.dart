import 'package:go_router/go_router.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';
import 'package:lune/ui/settings/notifiers/notifiers.dart';
import 'package:lune/ui/settings/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SettingsScreen {
  const SettingsScreen();

  static const path = '/settings';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create:
            (context) => SettingsNotifier(
              onSignOut: () {
                context.read<AuthNotifier>().signOut();
              },
              permissionRepository: context.read(),
              saveTokenUseCase: context.read(),
              authNotifier: context.read(),
              userPreferenceRepository: context.read(),
              signOutUseCase: context.read(),
              deleteAccountUsecase: context.read(),
            )..initialize(),
        child: const SettingsPage(),
      );
    },
    routes: routes,
  );
}
