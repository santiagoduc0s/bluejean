import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/ui.dart';
import 'package:provider/provider.dart';

class AppGoRouter extends CustomRouter {
  AppGoRouter(AuthNotifier authNotifier) : _authNotifier = authNotifier {
    router = GoRouter(
      refreshListenable: _authNotifier,
      navigatorKey: AppGlobalKey.rootNavigatorKey,
      initialLocation: SplashScreen.path,
      debugLogDiagnostics: true,
      routes: [
        SplashScreen.route(),
        PublicOnboardScreen.route(),
        SignInScreen.route(
          routes: [SignUpScreen.route(), ForgotPasswordScreen.route()],
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            final l10n = context.l10n;
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;

            final destinations = [
              (icon: Icons.person, label: l10n.profile),
              (icon: Icons.home, label: l10n.home),
              (icon: Icons.settings, label: l10n.settings),
            ];

            Future<void> onDestinationSelected(int index) async {
              unawaited(HapticFeedback.selectionClick());
              if (authNotifier.isNotAuthenticated && index == 0) {
                final dialog = context.read<CustomDialog>();
                var wantToSignIn = await dialog.showWithoutContext<bool>(
                  builder:
                      (context) => ConfirmDialog(
                        message: l10n.confirmSignInProfile,
                        confirmText: l10n.iWantIt,
                        cancelText: l10n.cancel,
                      ),
                );

                wantToSignIn ??= false;

                if (wantToSignIn) {
                  await pushNamed<void>(SignInScreen.path);
                  if (authNotifier.isNotAuthenticated) return;
                } else {
                  return;
                }
              }
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            }

            return isPortrait
                ? Scaffold(
                  body: navigationShell,
                  bottomNavigationBar: NavigationBar(
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: onDestinationSelected,
                    destinations: [
                      for (final d in destinations)
                        NavigationDestination(
                          icon: Icon(d.icon),
                          label: d.label,
                        ),
                    ],
                  ),
                )
                : Scaffold(
                  body: Row(
                    children: [
                      NavigationRail(
                        selectedIndex: navigationShell.currentIndex,
                        onDestinationSelected: onDestinationSelected,
                        labelType: NavigationRailLabelType.all,
                        destinations: [
                          for (final d in destinations)
                            NavigationRailDestination(
                              icon: Icon(d.icon),
                              label: Text(d.label),
                            ),
                        ],
                      ),
                      Expanded(child: navigationShell),
                    ],
                  ),
                );
          },
          branches: [
            StatefulShellBranch(routes: [ProfileScreen.route()]),
            StatefulShellBranch(routes: [HomeScreen.route()]),
            StatefulShellBranch(
              routes: [
                SettingsScreen.route(
                  routes: [
                    TermsConditionsScreen.route(),
                    PrivacyPolicyScreen.route(),
                    DevicesScreen.route(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: _redirect,
    );
  }

  final AuthNotifier _authNotifier;

  @override
  late RouterConfig<Object> router;

  final publicRoutes = [
    SignInScreen.path,
    '${SignInScreen.path}${SignUpScreen.path}',
    '${SignInScreen.path}${ForgotPasswordScreen.path}',
    PublicOnboardScreen.path,
  ];

  String? _redirect(BuildContext context, GoRouterState state) {
    if (state.matchedLocation == SplashScreen.path) {
      return null;
    }

    final isAuthenticated = _authNotifier.isAuthenticated;

    final isPublicRoute = publicRoutes.contains(state.matchedLocation);

    if (!isAuthenticated && !isPublicRoute) {
      return SignInScreen.path;
    }

    if (isPublicRoute && isAuthenticated) {
      return HomeScreen.path;
    }

    return null;
  }

  @override
  Future<T?> pushNamed<T>(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  }) async {
    return (router as GoRouter).pushNamed(
      name,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  @override
  void goNamed(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  }) {
    return (router as GoRouter).goNamed(
      name,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  @override
  void pop<T extends Object?>([T? result]) {
    return (router as GoRouter).pop<T>(result);
  }
}
