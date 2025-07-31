import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/domain/repositories/repositories.dart';

class ForgotPasswordUseCase {
  ForgotPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call({String? email, String? phone}) {
    if (email == null && phone == null) {
      throw ProvideAtLeastOneOfEmailOrPhoneException();
    }

    if (email != null && phone != null) {
      throw ProvideJustOneOfEmailOrPhoneException();
    }

    if (phone != null && !_isValidPhone(phone)) {
      throw InvalidPhoneNumberException();
    }

    if (email != null && !_isValidEmail(email)) {
      throw InvalidEmailException();
    }

    return _authRepository.forgotPassword(
      email: email,
      phone: phone,
    );
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}
