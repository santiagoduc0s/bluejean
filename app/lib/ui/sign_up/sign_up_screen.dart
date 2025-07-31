import 'package:go_router/go_router.dart';
import 'package:lune/ui/sign_up/notifiers/notifiers.dart';
import 'package:lune/ui/sign_up/widgets/views.dart';
import 'package:provider/provider.dart';

class SignUpScreen {
  const SignUpScreen();

  static const path = '/sign-up';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (context) => SignUpNotifier(
              signUpUseCase: context.read(),
              router: context.read(),
              localization: context.read(),
              snackbar: context.read(),
            ),
            child: const SignUpPage(),
          );
        },
        routes: routes,
      );
}
