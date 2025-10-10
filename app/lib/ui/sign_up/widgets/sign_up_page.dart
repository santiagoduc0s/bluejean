import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/form/fields/fields.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/core/ui/widgets/widgets.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/sign_up/notifiers/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    if (bottomPadding == 0) {
      bottomPadding = 4.space;
    }

    var topPadding = MediaQuery.of(context).padding.top;
    if (topPadding == 0) {
      topPadding = 4.space;
    }

    final form = context.read<SignUpNotifier>().form;

    final buttonsProvider = context.buttonStyles;
    final inputsProvider = context.inputStyles;

    final isSigningUp = context.select(
      (SignUpNotifier notifier) => notifier.isSigningUp,
    );

    final l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(l10n.signUp),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.space),
              child: Column(
                children: [
                  SizedBox(height: 8.space),
                  ReactiveFormBuilder(
                    form: () => form,
                    builder: (context, form, child) {
                      return Column(
                        children: [
                          // PhotoProfilePickerField(
                          //   formControlName: 'photo',
                          //   permissionRepository: context.read(),
                          //   dialog: context.read(),
                          //   imageQuality: context.read(),
                          // ),
                          // SizedBox(height: 4.space),
                          // ReactiveTextField<String>(
                          //   formControlName: 'firstName',
                          //   textInputAction: TextInputAction.next,
                          //   decoration: inputsProvider.primary.copyWith(
                          //     labelText: l10n.firstName,
                          //   ),
                          //   autofillHints: const [AutofillHints.givenName],
                          // ),
                          // SizedBox(height: 4.space),
                          // ReactiveTextField<String>(
                          //   formControlName: 'lastName',
                          //   textInputAction: TextInputAction.next,
                          //   decoration: inputsProvider.primary.copyWith(
                          //     labelText: l10n.lastName,
                          //   ),
                          //   autofillHints: const [AutofillHints.familyName],
                          // ),
                          SizedBox(height: 4.space),
                          ReactiveTextField<String>(
                            keyboardType: TextInputType.emailAddress,
                            formControlName: 'email',
                            textInputAction: TextInputAction.next,
                            decoration: inputsProvider.primary.copyWith(
                              labelText: l10n.email,
                            ),
                            autofillHints: const [AutofillHints.email],
                          ),
                          SizedBox(height: 4.space),
                          ReactivePasswordField(
                            formControlName: 'password',
                            textInputAction: TextInputAction.next,
                            decoration: inputsProvider.primary.copyWith(
                              labelText: l10n.password,
                            ),
                            autofillHints: const [AutofillHints.password],
                          ),
                          SizedBox(height: 4.space),
                          ReactivePasswordField(
                            formControlName: 'repeatPassword',
                            textInputAction: TextInputAction.done,
                            decoration: inputsProvider.primary.copyWith(
                              labelText: l10n.repeatPassword,
                            ),
                            autofillHints: const [AutofillHints.password],
                          ),
                        ],
                      );
                    },
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
                      isLoading: isSigningUp,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        context.read<SignUpNotifier>().signUp();
                      },
                      style: buttonsProvider.primaryFilled,
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
