import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/ui/animations/animations.dart';
import 'package:lune/domain/domain.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';
import 'package:lune/ui/preference/notifiers/notifiers.dart';
import 'package:lune/ui/sign_in/notifiers/notifiers.dart';
import 'package:lune/ui/sign_in/widgets/views.dart';
import 'package:provider/provider.dart';

class SignInScreen {
  const SignInScreen();

  static const path = '/sign-in';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    pageBuilder: (context, state) {
      return RouteAnimation.slideUpToDownTransition(
        key: state.pageKey,
        curve: Curves.elasticInOut,
        duration: const Duration(milliseconds: 1500),
        child: ChangeNotifierProvider(
          create:
              (context) => SignInNotifier(
                signInWithEmailPasswordUseCase: context.read(),
                saveFcmTokenUseCase: context.read(),
                authRepository: context.read(),
                onSignInSuccess: (
                  UserEntity user,
                  PreferenceEntity preference,
                ) {
                  context.read<AuthNotifier>().setUser(user);
                  context.read<PreferenceNotifier>().initialize(preference);
                },
                router: context.read(),
              ),
          child: const SignInPage(),
        ),
      );
    },
    routes: routes,
  );
}
