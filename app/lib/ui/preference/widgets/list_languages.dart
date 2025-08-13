import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/preference/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class ListLanguages extends StatelessWidget {
  const ListLanguages({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final buttonStyles = context.buttonStyles;
    final currentLocale =
        context.watch<PreferenceNotifier>().preference?.language;

    return SizedBox(
      child: FilledButton.tonal(
        onPressed: () async {
          var locale = await showModalBottomSheet<String?>(
            useRootNavigator: true,
            context: context,
            isScrollControlled: true,
            builder: (context) {
              final paddingBottom = context.paddingBottom;

              return Localizations.override(
                context: context,
                locale: const Locale('en'),
                child: Builder(
                  builder: (context) {
                    final l10n = context.l10n;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 2.space),
                        Container(
                          height: 1.space,
                          width: context.screenWidth * 0.1,
                          decoration: BoxDecoration(
                            color: colors.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(1.space),
                          ),
                        ),
                        SizedBox(height: 3.space),
                        ListTile(
                          leading: Icon(
                            Icons.settings_suggest,
                            color: colors.primary,
                          ),
                          title: Text(l10n.systemDefault),
                          trailing: currentLocale == null
                              ? Icon(Icons.check, color: colors.primary)
                              : null,
                          onTap: () {
                            context.pop('system');
                          },
                        ),
                        ListTile(
                          leading: Text(
                            '🇺🇸',
                            style: TextStyle(fontSize: 6.space),
                          ),
                          title: Text(l10n.settings_languageEnglish),
                          trailing: currentLocale == 'en'
                              ? Icon(Icons.check, color: colors.primary)
                              : null,
                          onTap: () {
                            context.pop('en');
                          },
                        ),
                        ListTile(
                          leading: Text(
                            '🇪🇸',
                            style: TextStyle(fontSize: 6.space),
                          ),
                          title: Text(l10n.settings_languageSpanish),
                          trailing: currentLocale == 'es'
                              ? Icon(Icons.check, color: colors.primary)
                              : null,
                          onTap: () {
                            context.pop('es');
                          },
                        ),
                        SizedBox(height: paddingBottom),
                      ],
                    );
                  },
                ),
              );
            },
          );

          if (!context.mounted || locale == null) return;

          if (locale == 'system') {
            locale = null;
          }

          await context.read<PreferenceNotifier>().setLanguage(locale);
        },
        style: buttonStyles.primaryFilledTonal,
        child: Text(l10n.settings_language),
      ),
    );
  }
}
