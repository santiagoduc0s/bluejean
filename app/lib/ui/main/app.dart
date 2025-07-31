import 'package:flutter/material.dart';
import 'package:lune/core/form/validators/validators.dart';
import 'package:lune/core/ui/themes/themes.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/l10n/gen_l10n/app_localizations.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/preference/notifiers/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class App extends StatelessWidget {
  const App({super.key});

  ThemeMode getThemeMode(String? theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Locale? getLocale(String? language) {
    if (language != null && language.isNotEmpty) {
      return Locale(language);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PreferenceNotifier>().preference;

    final theme = prefs?.theme;
    final locale = prefs?.language;

    return ReactiveFormConfig(
      validationMessages: validationMessages(context),
      child: MaterialApp.router(
        scaffoldMessengerKey: AppGlobalKey.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: UIThemeLight.instance.theme,
        darkTheme: UIThemeDark.instance.theme,
        themeMode: getThemeMode(theme),
        locale: getLocale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: context.read<CustomRouter>().router,
        builder: (context, child) {
          final textScaler = prefs?.textScaler;
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: textScaler != null
                  ? TextScaler.linear(textScaler)
                  : MediaQuery.of(context).textScaler,
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
