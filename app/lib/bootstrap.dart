import 'dart:async';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lune/core/config/config.dart';
import 'package:lune/core/dependencies/dependencies.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.instance.error(
          'Flutter Error: ${details.exception}',
          stackTrace: details.stack,
          metadata: {
            'library': details.library,
            'context': details.context?.toString(),
            'informationCollector': details.informationCollector?.toString(),
          },
        );
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        AppLogger.instance.critical(error.toString(), stackTrace: stack);
        return true;
      };

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
        Env.environment == 'prod',
      );

      AppLogger.instance.debug(Env.environment);

      AppProvider.init();

      runApp(MultiProvider(providers: providers, child: await builder()));
    },
    (error, stackTrace) {
      AppLogger.instance.error(
        'Zone Error: $error',
        stackTrace: stackTrace,
        metadata: {'zone': Zone.current.toString()},
      );
    },
  );
}
