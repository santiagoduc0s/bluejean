import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lune/core/config/config.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

class AppLoggerHelper {
  AppLoggerHelper._();

  static AuthNotifier? authNotifier;

  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  static Future<void> log(
    String message, {
    required LogLevel level,
    StackTrace? stackTrace,
    Map<String, dynamic> metadata = const {},
  }) async {
    switch (level) {
      case LogLevel.debug:
        _logger.d(message, stackTrace: stackTrace);
      case LogLevel.info:
        _logger.i(message, stackTrace: stackTrace);
      case LogLevel.warning:
        _logger.w(message, stackTrace: stackTrace);
      case LogLevel.error:
        unawaited(
          _sendLogToServer(
            message: message,
            type: level,
            stackTrace: stackTrace?.toString(),
            metadata: Map<String, dynamic>.from(metadata),
          ),
        );
        _logger.e(message, stackTrace: stackTrace);
      case LogLevel.critical:
        unawaited(
          _sendLogToServer(
            message: message,
            type: level,
            stackTrace: stackTrace?.toString(),
            metadata: Map<String, dynamic>.from(metadata),
          ),
        );
        _logger.f(message, stackTrace: stackTrace);
    }
  }

  static Future<void> _sendLogToServer({
    required String message,
    required LogLevel type,
    String? stackTrace,
    Map<String, dynamic>? metadata,
  }) async {
    final url = Uri.parse('${Env.baseUrl}/api/v1/logs');

    final extraData = <String, dynamic>{};

    if (authNotifier?.isAuthenticated != true) {
      final userId = authNotifier?.currentUser?.id;
      final email = authNotifier?.currentUser?.email;

      if (userId != null) extraData['user_id'] = userId;
      if (email != null) extraData['user_email'] = email;
    }

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'message': message,
        'type': _logLevelToString(type),
        'stack_trace': stackTrace,
        'metadata': {...?metadata, ...extraData},
        'environment': Env.environment,
      }),
    );
  }

  static String _logLevelToString(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 'info';
      case LogLevel.warning:
        return 'warning';
      case LogLevel.error:
        return 'error';
      case LogLevel.debug:
        return 'debug';
      case LogLevel.critical:
        return 'critical';
    }
  }

  static void debug(
    String message, {
    StackTrace? stackTrace,
    Map<String, Object> metadata = const {},
  }) =>
      log(
        message,
        level: LogLevel.debug,
        stackTrace: stackTrace,
        metadata: metadata,
      );

  static void info(
    String message, {
    StackTrace? stackTrace,
    Map<String, Object> metadata = const {},
  }) =>
      log(
        message,
        level: LogLevel.info,
        stackTrace: stackTrace,
        metadata: metadata,
      );

  static void warning(
    String message, {
    StackTrace? stackTrace,
    Map<String, Object> metadata = const {},
  }) =>
      log(
        message,
        level: LogLevel.warning,
        stackTrace: stackTrace,
        metadata: metadata,
      );

  static void error(
    String message, {
    StackTrace? stackTrace,
    Map<String, dynamic> metadata = const {},
  }) =>
      log(
        message,
        level: LogLevel.error,
        stackTrace: stackTrace,
        metadata: metadata,
      );

  static void critical(
    String message, {
    StackTrace? stackTrace,
    Map<String, dynamic> metadata = const {},
  }) =>
      log(
        message,
        level: LogLevel.critical,
        stackTrace: stackTrace,
        metadata: metadata,
      );
}
