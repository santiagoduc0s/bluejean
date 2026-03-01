import 'package:flutter/foundation.dart';
import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/form/validators/validators.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/usecases/auth/auth.dart';
import 'package:lune/router/router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpNotifier extends ChangeNotifier with NotifierEffects {
  SignUpNotifier({required this.signUpUseCase, required this.router});

  final SignUpUseCase signUpUseCase;
  final CustomRouter router;
  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  bool _isSigningUp = false;
  bool get isSigningUp => _isSigningUp;

  final form = FormGroup(
    {
      'email': FormControl<String>(
        value: '',
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        value: '',
        validators: [Validators.required, Validators.minLength(8)],
      ),
      'repeatPassword': FormControl<String>(
        value: '',
        validators: [Validators.required],
      ),
    },
    validators: [
      CustomMustMatchValidator(
        controlName: 'password',
        matchingControlName: 'repeatPassword',
      ),
    ],
  );

  Future<void> signUp() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    if (isSigningUp) return;

    _setSigningUp(true);

    try {
      await signUpUseCase.call(
        email: form.control('email').value as String,
        password: form.control('password').value as String,
      );

      router.pop({
        'email': form.control('email').value as String,
        'password': form.control('password').value as String,
      });
    } on EmailAlreadyInUseException {
      emitErrorSnackbar((l10n) => l10n.signUp_emailAlreadyInUse);
    } on WeakPasswordException {
      emitErrorSnackbar((l10n) => l10n.signUp_weakPassword);
    } on InvalidEmailFormatException {
      emitErrorSnackbar((l10n) => l10n.signUp_InvalidEmailFormat);
    } catch (e, s) {
      emitErrorSnackbar((l10n) => l10n.generalError);
      logError(e, s);
    } finally {
      _setSigningUp(false);
    }
  }

  void _setSigningUp(bool value) {
    _isSigningUp = value;
    notifyListeners();
  }
}
