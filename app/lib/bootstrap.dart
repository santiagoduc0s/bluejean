import 'dart:async';
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
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
    Env.environment == 'prod',
  );

  AppLogger.instance.debug(Env.environment);

  runApp(
    MultiProvider(
      providers: providers,
      child: await builder(),
    ),
  );
}
