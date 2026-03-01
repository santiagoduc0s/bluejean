import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lune/core/config/config.dart';
import 'package:lune/core/dependencies/dependencies.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/usecases/usecases.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';
import 'package:lune/ui/preference/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      FlutterError.onError = (FlutterErrorDetails details) {
        AppLoggerHelper.error(
          'Flutter Error: ${details.exception}',
          stackTrace: details.stack,
        );
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        AppLoggerHelper.critical(error.toString(), stackTrace: stack);
        return !kDebugMode;
      };

      AppLoggerHelper.debug(Env.environment);

      initServiceLocator();

      await _initializeApp();

      runApp(MultiProvider(providers: providers, child: await builder()));
    },
    (error, stackTrace) {
      AppLoggerHelper.error('Zone Error: $error', stackTrace: stackTrace);
    },
  );
}

Future<void> _initializeApp() async {
  try {
    await getIt<PreferenceNotifier>().initialize();

    final results = await Future.wait<Object?>([
      Future<Object?>.delayed(300.ms), // Min time native splash
      getIt<OpenAppUseCase>().call(),
    ]);

    final user = results[1] as UserEntity?;

    getIt<AuthNotifier>().initialize(user);
  } catch (e, s) {
    AppLoggerHelper.error(e.toString(), stackTrace: s);
  } finally {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }
}
