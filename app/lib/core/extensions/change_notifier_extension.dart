import 'package:flutter/material.dart';
import 'package:lune/core/ui/alerts/alerts.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/l10n/gen_l10n/app_localizations.dart';

extension ChangeNotifierX on ChangeNotifier {
  void logError(Object error, [StackTrace? stackTrace]) {
    AppLoggerHelper.error(error.toString(), stackTrace: stackTrace);
  }

  void logDebug(Object message, [StackTrace? stackTrace]) {
    AppLoggerHelper.debug(message.toString(), stackTrace: stackTrace);
  }

  void primarySnackbar(String text, [void Function()? onTap]) {
    SnackbarHelper.success(text, onTap: onTap);
  }

  void errorSnackbar(String text, [void Function()? onTap]) {
    SnackbarHelper.error(text, onTap: onTap);
  }

  Future<bool> dialogConfirm({
    required String message,
    required String confirmText,
    required String cancelText,
  }) {
    return DialogHelper.confirm(
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }

  Future<void> dialogInfo({
    required String message,
    required String confirmText,
  }) {
    return DialogHelper.info(message: message, confirmText: confirmText);
  }

  AppLocalizations get localization => AppProvider.get<Localization>().tr;
}
