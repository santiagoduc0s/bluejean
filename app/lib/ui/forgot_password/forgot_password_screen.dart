import 'package:go_router/go_router.dart';
import 'package:lune/ui/forgot_password/notifiers/notifiers.dart';
import 'package:lune/ui/forgot_password/widgets/views.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen {
  const ForgotPasswordScreen();

  static const path = '/forgot-password';

  static GoRoute route({
    List<RouteBase> routes = const [],
  }) =>
      GoRoute(
        path: path,
        name: path,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';

          return ChangeNotifierProvider(
            create: (context) => ForgotPasswordNotifier(
              forgotPasswordUseCase: context.read(),
              snackbar: context.read(),
              localization: context.read(),
              router: context.read(),
            )..init(email),
            child: const ForgotPasswordPage(),
          );
        },
        routes: routes,
      );
}
