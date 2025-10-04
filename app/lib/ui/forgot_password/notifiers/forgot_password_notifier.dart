import 'package:flutter/foundation.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/domain/usecases/usecases.dart';
import 'package:lune/router/router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ForgotPasswordNotifier extends ChangeNotifier {
  ForgotPasswordNotifier({
    required this.forgotPasswordUseCase,
    required this.router,
  });

  final ForgotPasswordUseCase forgotPasswordUseCase;
  final CustomRouter router;

  final form = FormGroup({
    'email': FormControl<String>(
      value: '',
      validators: [Validators.required, Validators.email],
    ),
  });

  bool isSendingEmail = false;

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  void setIsSendingEmail(bool value) {
    isSendingEmail = value;
    notifyListeners();
  }

  void init(String? initialEmail) {
    if (initialEmail != null && initialEmail.isNotEmpty) {
      form.control('email').value = initialEmail;
    }
  }

  Future<void> sendForgotPasswordEmail() async {
    if (isSendingEmail) return;

    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    setIsSendingEmail(true);

    try {
      final email = form.control('email').value as String;
      await forgotPasswordUseCase.call(email: email);

      primarySnackbar(localization.forgotPassword_emailSent);

      router.pop(email);
    } catch (e, s) {
      errorSnackbar(localization.generalError);
      logError(e, s);
    } finally {
      setIsSendingEmail(false);
    }
  }
}
