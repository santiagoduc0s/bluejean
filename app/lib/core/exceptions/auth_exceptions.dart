import 'package:lune/core/exceptions/base_exception.dart';

/// Email verification exception.
class EmailNotVerifiedException extends BaseException {
  EmailNotVerifiedException([super.message]);
}

/// Wrong password exception.
class WrongPasswordException extends BaseException {
  WrongPasswordException([super.message]);
}

/// Invalid email format exception.
class InvalidEmailFormatException extends BaseException {
  InvalidEmailFormatException([super.message]);
}

/// Invalid credential exception.
class InvalidCredentialException extends BaseException {
  InvalidCredentialException([super.message]);
}

/// Email already in use exception.
class EmailAlreadyInUseException extends BaseException {
  EmailAlreadyInUseException([super.message]);
}

/// Weak password exception.
class WeakPasswordException extends BaseException {
  WeakPasswordException([super.message]);
}

/// User disabled exception.
class UserDisabledException extends BaseException {
  UserDisabledException([super.message]);
}

/// Account exists with different credential exception.
class AccountExistsWithDifferentCredentialException extends BaseException {
  AccountExistsWithDifferentCredentialException([super.message]);
}

/// User not found exception.
class UserNotFoundException extends BaseException {
  UserNotFoundException([super.message]);
}

/// Permission denied exception.
class PermissionDeniedUsersException extends BaseException {
  PermissionDeniedUsersException([super.message]);
}

/// Provide just one of email or phone exception.
class ProvideJustOneOfEmailOrPhoneException extends BaseException {
  ProvideJustOneOfEmailOrPhoneException([super.message]);
}

/// Provide at least one of email or phone exception.
class ProvideAtLeastOneOfEmailOrPhoneException extends BaseException {
  ProvideAtLeastOneOfEmailOrPhoneException([super.message]);
}

/// Invalid verification code exception.
class InvalidVerificationCodeException extends BaseException {
  InvalidVerificationCodeException([super.message]);
}

/// User is unauthenticated exception.
class UserUnauthenticatedException extends BaseException {
  UserUnauthenticatedException([super.message]);
}

/// Unauthorized exception.
class UnauthorizedException extends BaseException {
  UnauthorizedException([super.message]);
}
