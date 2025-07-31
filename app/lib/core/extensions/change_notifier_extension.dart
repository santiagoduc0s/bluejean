import 'package:flutter/material.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';
import 'package:lune/core/ui/alerts/snackbar/snackbar.dart';
import 'package:lune/core/utils/utils.dart';

extension ChangeNotifierX on ChangeNotifier {
  void logError(
    Object error, [
    StackTrace? stackTrace,
  ]) {
    AppLogger.instance.error(error.toString(), stackTrace: stackTrace);
  }

  void logDebug(
    Object message, [
    StackTrace? stackTrace,
  ]) {
    AppLogger.instance.debug(message.toString(), stackTrace: stackTrace);
  }

  void primarySnackbar(
    CustomSnackbar snackbar,
    String text, [
    void Function()? onTap,
  ]) {
    snackbar.show(
      PrimarySnackBar(
        text: text,
        onTap: onTap,
      ),
    );
  }

  void errorSnackbar(
    CustomSnackbar snackbar,
    String text, [
    void Function()? onTap,
  ]) {
    snackbar.show(
      ErrorSnackBar(
        text: text,
        onTap: onTap,
      ),
    );
  }

  Future<bool> dialogConfirm(
    CustomDialog dialog, {
    required String message,
    required String confirmText,
    required String cancelText,
  }) {
    return dialog.confirm(
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }

  Future<void> dialogInfo(
    CustomDialog dialog, {
    required String message,
    required String confirmText,
  }) {
    return dialog.info(
      message: message,
      confirmText: confirmText,
    );
  }
}
