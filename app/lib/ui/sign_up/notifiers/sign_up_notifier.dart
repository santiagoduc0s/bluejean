import 'package:flutter/foundation.dart';
import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/form/validators/validators.dart';
import 'package:lune/domain/usecases/auth/auth.dart';
import 'package:lune/router/router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpNotifier extends ChangeNotifier {
  SignUpNotifier({required this.signUpUseCase, required this.router});

  final SignUpUseCase signUpUseCase;
  final CustomRouter router;
  bool isSigningUp = false;

  final form = FormGroup(
    {
      // 'photo': FormControl<XFile?>(),
      // 'firstName': FormControl<String>(
      //   value: '',
      //   // validators: [Validators.required],
      // ),
      // 'lastName': FormControl<String>(
      //   value: '',
      //   // validators: [Validators.required],
      // ),
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
      errorSnackbar(localization.signUp_emailAlreadyInUse);
    } on WeakPasswordException {
      errorSnackbar(localization.signUp_weakPassword);
    } on InvalidEmailFormatException {
      errorSnackbar(localization.signUp_InvalidEmailFormat);
    } catch (e, s) {
      errorSnackbar(localization.generalError);
      logError(e, s);
    } finally {
      _setSigningUp(false);
    }
  }

  void _setSigningUp(bool value) {
    isSigningUp = value;
    notifyListeners();
  }
}
