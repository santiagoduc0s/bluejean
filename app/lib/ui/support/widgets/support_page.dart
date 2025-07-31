import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/form/fields/support_image_picker_field.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/core/ui/widgets/widgets.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/support/notifiers/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.read<SupportNotifier>().form;
    final isCreatingTicket = context.select(
      (SupportNotifier notifier) => notifier.isCreatingTicket,
    );

    final buttonsProvider = context.buttonStyles;
    final inputsProvider = context.inputStyles;
    final l10n = context.l10n;

    var bottomPadding = MediaQuery.of(context).padding.bottom;
    if (bottomPadding == 0) {
      bottomPadding = 4.space;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.support),
        backgroundColor: Colors.transparent,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.space),
              child: Column(
                children: [
                  ReactiveForm(
                    formGroup: form,
                    child: Column(
                      children: [
                        4.spaceY,
                        Text(
                          l10n.supportDescription,
                          style: context.textStyles.bodyLarge,
                        ),
                        4.spaceY,
                        ReactiveTextField<String>(
                          formControlName: 'email',
                          textInputAction: TextInputAction.next,
                          decoration: inputsProvider.primary.copyWith(
                            labelText: l10n.email,
                          ),
                        ),
                        4.spaceY,
                        ReactiveTextField<String>(
                          formControlName: 'title',
                          textInputAction: TextInputAction.next,
                          decoration: inputsProvider.primary.copyWith(
                            labelText: l10n.title,
                          ),
                        ),
                        4.spaceY,
                        ReactiveTextField<String>(
                          formControlName: 'description',
                          textInputAction: TextInputAction.newline,
                          maxLines: 6,
                          decoration: inputsProvider.primary.copyWith(
                            labelText: l10n.description,
                            alignLabelWithHint: true,
                          ),
                        ),
                        4.spaceY,
                        SupportImagePickerField(
                          formControlName: 'images',
                          maxImages: 5,
                          permissionRepository: context.read(),
                          dialog: context.read(),
                          localization: context.read(),
                          snackbar: context.read(),
                        ),
                      ],
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
                      isLoading: isCreatingTicket,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        context.read<SupportNotifier>().createTicket();
                      },
                      style: buttonsProvider.primaryFilled,
                      child: Text(l10n.submit),
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
