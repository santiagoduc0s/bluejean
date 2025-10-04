import 'package:go_router/go_router.dart';
import 'package:lune/ui/support/notifiers/notifiers.dart';
import 'package:lune/ui/support/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SupportScreen {
  const SupportScreen();

  static const path = '/support';

  static GoRoute route({List<RouteBase> routes = const []}) {
    return GoRoute(
      path: path,
      name: path,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create:
              (context) => SupportNotifier(
                supportRepository: context.read(),
                remoteStorageRepository: context.read(),
              ),
          child: const SupportPage(),
        );
      },
      routes: routes,
    );
  }
}
