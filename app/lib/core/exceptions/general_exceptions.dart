import 'package:lune/core/exceptions/base_exception.dart';

class InvalidEmailException extends BaseException {
  InvalidEmailException([super.message]);
}

class InvalidPhoneNumberException extends BaseException {
  InvalidPhoneNumberException([super.message]);
}

class NoInternetConnectionException extends BaseException {
  NoInternetConnectionException([super.message]);
}

class CancellOperationException extends BaseException {
  CancellOperationException([super.message]);
}
