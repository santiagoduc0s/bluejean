import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/domain/usecases/usecases.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/forgot_password/widgets/views.dart';
import 'package:lune/ui/sign_up/widgets/views.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInNotifier extends ChangeNotifier {
  SignInNotifier({
    required this.signInWithEmailPasswordUseCase,
    required this.signInWithAppleUseCase,
    required this.signInWithGoogleUseCase,
    required this.saveFcmTokenUseCase,
    required this.authRepository,
    required this.router,
    required this.onSignInSuccess,
  });

  final SignInWithEmailPasswordUseCase signInWithEmailPasswordUseCase;
  final SignInWithAppleUseCase signInWithAppleUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SaveFcmTokenUseCase saveFcmTokenUseCase;
  final AuthRepository authRepository;
  final CustomRouter router;
  final void Function(
    UserEntity user,
    PreferenceEntity preference,
  ) onSignInSuccess;

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

  bool isSigningIn = false;

  Future<void> signInWithApple() async {
    if (isSigningIn) return;

    _setSigningIn(true);

    try {
      final data = await signInWithAppleUseCase.call();
      await saveFcmTokenUseCase.call();

      onSignInSuccess(
        data['user'] as UserEntity,
        data['preference'] as PreferenceEntity,
      );
    } on CancellOperationException {
      return;
    } on NoInternetConnectionException {
      errorSnackbar(localization.notConnected);
    } catch (e, s) {
      errorSnackbar(localization.generalError);

      logError(e, s);
    } finally {
      _setSigningIn(false);
    }
  }

  Future<void> signInWithGoogle() async {
    if (isSigningIn) return;

    _setSigningIn(true);

    try {
      final data = await signInWithGoogleUseCase.call();
      await saveFcmTokenUseCase.call();

      onSignInSuccess(
        data['user'] as UserEntity,
        data['preference'] as PreferenceEntity,
      );
    } on CancellOperationException {
      return;
    } on NoInternetConnectionException {
      errorSnackbar(localization.notConnected);
    } catch (e, s) {
      errorSnackbar(localization.generalError);

      logError(e, s);
    } finally {
      _setSigningIn(false);
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    if (isSigningIn) return;

    _setSigningIn(true);

    try {
      final data = await signInWithEmailPasswordUseCase.call(
        email: form.control('email').value as String,
        password: form.control('password').value as String,
      );

      await saveFcmTokenUseCase.call();

      onSignInSuccess(
        data['user'] as UserEntity,
        data['preference'] as PreferenceEntity,
      );

      // router.pop();
    } on EmailNotVerifiedException {
      errorSnackbar(localization.signIn_emailDoesNotVerified);
    } on InvalidCredentialException {
      errorSnackbar(localization.signIn_invalidCredential);
    } on WrongPasswordException {
      errorSnackbar(localization.signIn_wrongPassword);
    } on UserDisabledException {
      errorSnackbar(localization.signIn_userDisabled);
    } on NoInternetConnectionException {
      errorSnackbar(localization.notConnected);
    } catch (e, s) {
      errorSnackbar(localization.generalError);

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
      queryParameters: {
        'email': form.control('email').value as String,
      },
    );

    if (email == null) return;

    form.control('email').value = email;
  }

  void _setSigningIn(bool value) {
    isSigningIn = value;
    notifyListeners();
  }
}
