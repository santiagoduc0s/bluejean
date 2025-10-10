import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/form/fields/fields.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/core/ui/widgets/widgets.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/sign_in/notifiers/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    if (bottomPadding == 0) {
      bottomPadding = 4.space;
    }

    final form = context.read<SignInNotifier>().form;

    final buttons = context.buttonStyles;
    final inputs = context.inputStyles;

    final isSingingWithEmailAndPassword = context.select(
      (SignInNotifier notifier) => notifier.isSigningIn,
    );

    final l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(l10n.signIn),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.space),
              child: Column(
                children: [
                  SizedBox(height: 8.space),
                  ReactiveForm(
                    formGroup: form,
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          ReactiveTextField<String>(
                            keyboardType: TextInputType.emailAddress,
                            formControlName: 'email',
                            textInputAction: TextInputAction.next,
                            decoration: inputs.primary.copyWith(
                              labelText: l10n.email,
                            ),
                            autofillHints: const [AutofillHints.email],
                          ),
                          SizedBox(height: 4.space),
                          ReactivePasswordField(
                            formControlName: 'password',
                            textInputAction: TextInputAction.done,
                            decoration: inputs.primary.copyWith(
                              labelText: l10n.password,
                            ),
                            autofillHints: const [AutofillHints.password],
                          ),
                          SizedBox(height: 4.space),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Text(l10n.forgotMyPassword),
                                onPressed:
                                    () =>
                                        context
                                            .read<SignInNotifier>()
                                            .goToForgotPassword(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 4.space,
                right: 4.space,
                top: 4.space,
                bottom: bottomPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: UISpacing.infinity,
                    child: LoadingButton(
                      type: ButtonType.filled,
                      isLoading: isSingingWithEmailAndPassword,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        context
                            .read<SignInNotifier>()
                            .signInWithEmailAndPassword();
                      },
                      style: buttons.primaryFilled,
                      child: Text(l10n.signIn),
                    ),
                  ),
                  SizedBox(height: 4.space),
                  if (!kIsWeb && Platform.isIOS) ...[
                    const SignInWithAppleButton(),
                    SizedBox(height: 4.space),
                  ],
                  const SignUpWithGoogleButton(),
                  SizedBox(height: 4.space),
                  SizedBox(
                    width: UISpacing.infinity,
                    child: LoadingButton(
                      type: ButtonType.outlined,
                      onPressed: () {
                        context.read<SignInNotifier>().goToSignUp();
                      },
                      style: buttons.primaryOutlined,
                      child: Text(l10n.signUp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignInWithAppleButton extends StatelessWidget {
  const SignInWithAppleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttonStyles;
    final l10n = context.l10n;

    final isSingingWithEmailAndPassword = context.select(
      (SignInNotifier notifier) => notifier.isSigningIn,
    );

    return SizedBox(
      width: UISpacing.infinity,
      child: OutlinedButton(
        style: buttons.primaryOutlined,
        onPressed:
            isSingingWithEmailAndPassword
                ? null
                : () {
                  context.read<SignInNotifier>().signInWithApple();
                },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apple, size: 5.5.space),
            SizedBox(width: 2.space),
            Text(l10n.signInWithApple),
          ],
        ),
      ),
    );
  }
}

class SignUpWithGoogleButton extends StatelessWidget {
  const SignUpWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttonStyles;
    final l10n = context.l10n;

    final isSingingWithEmailAndPassword = context.select(
      (SignInNotifier notifier) => notifier.isSigningIn,
    );

    return SizedBox(
      width: UISpacing.infinity,
      child: OutlinedButton(
        style: buttons.primaryOutlined,
        onPressed:
            isSingingWithEmailAndPassword
                ? null
                : () {
                  context.read<SignInNotifier>().signInWithGoogle();
                },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png',
              height: 4.2.space,
              width: 4.2.space,
            ),
            SizedBox(width: 2.space),
            Text(l10n.signInWithGoogle),
          ],
        ),
      ),
    );
  }
}
