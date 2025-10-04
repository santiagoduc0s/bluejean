import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/form/form.dart';
import 'package:lune/core/ui/ui.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/profile/notifiers/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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

    final form = context.read<ProfileNotifier>().form;

    final buttonsProvider = context.buttonStyles;
    final inputsProvider = context.inputStyles;
    final textsProvider = context.textStyles;
    final colorsProvider = context.colors;

    final isUpdatingData = context.select(
      (ProfileNotifier notifier) => notifier.isUpdatingData,
    );

    final l10n = context.l10n;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorsProvider.primary.withValues(alpha: 0.5),
              colorsProvider.secondary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title:
                  Text(
                        l10n.profile,
                        style: textsProvider.headlineLarge.copyWith(
                          color: colorsProvider.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .slideY(duration: 700.ms, curve: Curves.easeInOut)
                      .fadeIn(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.space),
                child: ReactiveFormBuilder(
                  form: () => form,
                  builder: (context, form, child) {
                    return Column(
                      children: [
                        PhotoProfilePickerField(
                              formControlName: 'photo',
                              permissionRepository: context.read(),
                              imageQuality: context.read(),
                            )
                            .animate()
                            .slideY(
                              duration: 700.ms,
                              curve: Curves.easeInOut,
                              delay: 400.ms,
                            )
                            .fadeIn(),
                        SizedBox(height: 4.space),
                        ReactiveForm(
                              formGroup: form,
                              child: Column(
                                children: [
                                  ReactiveTextField<String>(
                                    formControlName: 'name',
                                    textInputAction: TextInputAction.next,
                                    decoration: inputsProvider.primary.copyWith(
                                      hintText: l10n.name,
                                      fillColor:
                                          colorsProvider.surfaceContainer,
                                      filled: true,
                                    ),
                                  ),
                                  SizedBox(height: 4.space),
                                  ReactiveTextField<String>(
                                    keyboardType: TextInputType.emailAddress,
                                    formControlName: 'email',
                                    textInputAction: TextInputAction.next,
                                    decoration: inputsProvider.primary.copyWith(
                                      hintText: l10n.email,
                                      fillColor:
                                          colorsProvider.surfaceContainer,
                                      filled: true,
                                    ),
                                  ),
                                  SizedBox(height: 1.space),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.space,
                                    ),
                                    child: Text(
                                      l10n.profileEmailNote,
                                      style: textsProvider.bodySmall.copyWith(
                                        color: colorsProvider.onSurface
                                            .withValues(alpha: 0.6),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .slide(
                              begin: const Offset(0, 1),
                              curve: Curves.easeInOut,
                              end: Offset.zero,
                              delay: 800.ms,
                              duration: 700.ms,
                            )
                            .fadeIn(),
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child:
                  Padding(
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
                                isLoading: isUpdatingData,
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<ProfileNotifier>()
                                      .updateProfile();
                                },
                                style: buttonsProvider.primaryFilled,
                                child: Text(l10n.save),
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .slide(
                        begin: const Offset(0, 1),
                        curve: Curves.easeInOut,
                        end: Offset.zero,
                        delay: 900.ms,
                        duration: 700.ms,
                      )
                      .fadeIn(),
            ),
          ],
        ),
      ),
    );
  }
}
