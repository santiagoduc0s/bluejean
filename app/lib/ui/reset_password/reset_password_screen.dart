import 'package:go_router/go_router.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';
import 'package:lune/ui/reset_password/notifiers/notifiers.dart';
import 'package:lune/ui/reset_password/widgets/views.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen {
  const ResetPasswordScreen();

  static const path = '/reset-password';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create:
            (context) => ResetPasswordNotifier(
              signInWithEmailPasswordUseCase: context.read(),
              authRepository: context.read(),
              user: context.read<AuthNotifier>().currentUser!,
              localization: context.read(),
              snackbar: context.read(),
              router: context.read(),
            ),
        child: const ResetPasswordPage(),
      );
    },
    routes: routes,
  );
}
