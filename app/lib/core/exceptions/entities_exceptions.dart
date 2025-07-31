import 'package:lune/core/exceptions/base_exception.dart';

class NotFoundException extends BaseException {
  NotFoundException([super.message]);
}

class ValidationException extends BaseException {
  ValidationException([super.message]);
}

class DuplicateEntryException extends BaseException {
  DuplicateEntryException([super.message]);
}

class UnauthorizedException extends BaseException {
  UnauthorizedException([super.message]);
}

class ForbiddenException extends BaseException {
  ForbiddenException([super.message]);
}

class InvalidOperationException extends BaseException {
  InvalidOperationException([super.message]);
}

class DatabaseException extends BaseException {
  DatabaseException([super.message]);
}

class NetworkException extends BaseException {
  NetworkException([super.message]);
}

class TimeoutException extends BaseException {
  TimeoutException([super.message]);
}
