import 'package:go_router/go_router.dart';
import 'package:lune/core/ui/widgets/widgets.dart';
import 'package:lune/ui/ui.dart';
import 'package:provider/provider.dart';

class DevicesScreen {
  const DevicesScreen();

  static const path = '/devices';

  static GoRoute route({List<RouteBase> routes = const []}) {
    return GoRoute(
      path: path,
      name: path,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create:
              (context) => DevicesNotifier(
                deviceRepository: context.read(),
                signOutUseCase: context.read(),
                onSignOut: () {
                  context.read<AuthNotifier>().signOut();
                },
              )..loadDevices(),
          child: const EffectListener<DevicesNotifier>(
            child: DevicesPage(),
          ),
        );
      },
      routes: routes,
    );
  }
}
