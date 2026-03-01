import 'package:flutter/material.dart';
import 'package:lune/core/utils/utils.dart';

extension ChangeNotifierX on ChangeNotifier {
  void logError(Object error, [StackTrace? stackTrace]) {
    AppLoggerHelper.error(error.toString(), stackTrace: stackTrace);
  }

  void logDebug(Object message, [StackTrace? stackTrace]) {
    AppLoggerHelper.debug(message.toString(), stackTrace: stackTrace);
  }
}
