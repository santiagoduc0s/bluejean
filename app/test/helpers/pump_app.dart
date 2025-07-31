import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lune/l10n/gen_l10n/app_localizations.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
