import 'package:logger/logger.dart';

enum LogLevel { debug, info, warning, error, critical }

class AppLoggerHelper {
  AppLoggerHelper._();

  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  static void log(
    String message, {
    required LogLevel level,
    StackTrace? stackTrace,
  }) {
    switch (level) {
      case LogLevel.debug:
        _logger.d(message, stackTrace: stackTrace);
      case LogLevel.info:
        _logger.i(message, stackTrace: stackTrace);
      case LogLevel.warning:
        _logger.w(message, stackTrace: stackTrace);
      case LogLevel.error:
        _logger.e(message, stackTrace: stackTrace);
      case LogLevel.critical:
        _logger.f(message, stackTrace: stackTrace);
    }
  }

  static void debug(String message, {StackTrace? stackTrace}) =>
      log(message, level: LogLevel.debug, stackTrace: stackTrace);

  static void info(String message, {StackTrace? stackTrace}) =>
      log(message, level: LogLevel.info, stackTrace: stackTrace);

  static void warning(String message, {StackTrace? stackTrace}) =>
      log(message, level: LogLevel.warning, stackTrace: stackTrace);

  static void error(String message, {StackTrace? stackTrace}) =>
      log(message, level: LogLevel.error, stackTrace: stackTrace);

  static void critical(String message, {StackTrace? stackTrace}) =>
      log(message, level: LogLevel.critical, stackTrace: stackTrace);
}
