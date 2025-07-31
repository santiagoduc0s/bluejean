import 'package:flutter/material.dart';

/// This wrapper is useful for put screens above the app
/// to block the normal interaction as could be no internet connection,
/// payment, security, a very important alert, etc.
class AppWrapper extends StatelessWidget {
  const AppWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: const [],
    //   child: AppWrapperContent(child: child),
    // );

    return AppWrapperContent(child: child);
  }
}

class AppWrapperContent extends StatelessWidget {
  const AppWrapperContent({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
      ],
    );
  }
}
