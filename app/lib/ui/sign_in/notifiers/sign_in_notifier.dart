import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/usecases/usecases.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/forgot_password/widgets/views.dart';
import 'package:lune/ui/sign_up/widgets/views.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInNotifier extends ChangeNotifier with NotifierEffects {
  SignInNotifier({
    required this.signInWithEmailPasswordUseCase,
    required this.saveFcmTokenUseCase,
    required this.router,
    required this.onSignInSuccess,
  });

  final SignInWithEmailPasswordUseCase signInWithEmailPasswordUseCase;
  final SaveFcmTokenUseCase saveFcmTokenUseCase;
  final CustomRouter router;
  final void Function(UserEntity user) onSignInSuccess;

  final FormGroup form = FormGroup({
    'email': FormControl<String>(
      value: '',
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      value: '',
      validators: [Validators.required, Validators.minLength(8)],
    ),
  });

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;

  Future<void> signInWithEmailAndPassword() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    if (isSigningIn) return;

    _setSigningIn(true);

    try {
      final user = await signInWithEmailPasswordUseCase.call(
        email: form.control('email').value as String,
        password: form.control('password').value as String,
      );

      if (user != null) {
        onSignInSuccess(user);
        unawaited(saveFcmTokenUseCase.call().catchError((_) {}));
      } else {
        emitErrorSnackbar((l10n) => l10n.generalError);
      }
    } on EmailNotVerifiedException {
      emitErrorSnackbar((l10n) => l10n.signIn_emailDoesNotVerified);
    } on InvalidCredentialException {
      emitErrorSnackbar((l10n) => l10n.signIn_invalidCredential);
    } on WrongPasswordException {
      emitErrorSnackbar((l10n) => l10n.signIn_wrongPassword);
    } on UserDisabledException {
      emitErrorSnackbar((l10n) => l10n.signIn_userDisabled);
    } on NoInternetConnectionException {
      emitErrorSnackbar((l10n) => l10n.notConnected);
    } catch (e, s) {
      emitErrorSnackbar((l10n) => l10n.generalError);

      logError(e, s);
    } finally {
      _setSigningIn(false);
    }
  }

  Future<void> goToSignUp() async {
    final result = await router.pushNamed<Map<String, String>>(
      SignUpScreen.path,
    );

    if (result == null) return;

    form.control('email').value = result['email'];
    form.control('password').value = result['password'];

    await Future<void>.delayed(500.ms);

    await signInWithEmailAndPassword();
  }

  Future<void> goToForgotPassword() async {
    final email = await router.pushNamed<String>(
      ForgotPasswordScreen.path,
      queryParameters: {'email': form.control('email').value as String},
    );

    if (email == null) return;

    form.control('email').value = email;
  }

  void _setSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }
}
