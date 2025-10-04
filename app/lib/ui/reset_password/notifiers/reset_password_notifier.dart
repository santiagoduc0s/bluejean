import 'package:flutter/foundation.dart';
import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/form/validators/validators.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/domain/usecases/auth/auth.dart';
import 'package:lune/router/router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ResetPasswordNotifier extends ChangeNotifier {
  ResetPasswordNotifier({
    required SignInWithEmailPasswordUseCase signInWithEmailPasswordUseCase,
    required AuthRepository authRepository,
    required UserEntity user,
    required CustomRouter router,
  }) : _signInWithEmailPasswordUseCase = signInWithEmailPasswordUseCase,
       _authRepository = authRepository,
       _user = user,
       _router = router;

  final SignInWithEmailPasswordUseCase _signInWithEmailPasswordUseCase;
  final AuthRepository _authRepository;
  final UserEntity _user;
  final CustomRouter _router;

  final FormGroup form = FormGroup(
    {
      'password': FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.minLength(8),
        ],
      ),
      'newPassword': FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.minLength(8),
        ],
      ),
      'repeatPassword': FormControl<String>(
        value: '',
        validators: [Validators.required],
      ),
    },
    validators: [
      CustomMustMatchValidator(
        controlName: 'newPassword',
        matchingControlName: 'repeatPassword',
      ),
    ],
  );

  bool _isResetting = false;
  bool get isResetting => _isResetting;

  void setIsResetting(bool value) {
    _isResetting = value;
    notifyListeners();
  }

  Future<void> resetPassword() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    if (_isResetting) return;

    setIsResetting(true);

    try {
      await _signInWithEmailPasswordUseCase.call(
        email: _user.email,
        password: form.control('password').value as String,
      );

      await _authRepository.updatePassword(
        password: form.control('newPassword').value as String,
      );

      primarySnackbar(localization.settings_passwordUpdated);

      _router.pop();
    } on InvalidCredentialException {
      errorSnackbar(localization.signIn_invalidCredential);
    } on NoInternetConnectionException {
      errorSnackbar(localization.notConnected);
    } catch (e, s) {
      errorSnackbar(localization.generalError);

      logError(e, s);
    } finally {
      setIsResetting(false);
    }
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
}
