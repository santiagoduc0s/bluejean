import 'package:go_router/go_router.dart';
import 'package:lune/ui/home/notifiers/notifiers.dart';
import 'package:lune/ui/home/widgets/home_page.dart';
import 'package:provider/provider.dart';

class HomeScreen {
  const HomeScreen();

  static const path = '/home';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (context) => HomeNotifier(),
        child: const HomePage(),
      );
    },
    routes: routes,
  );
}
