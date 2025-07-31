import 'package:flutter/material.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/ui/preference/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class ToggleButtonTheme extends StatelessWidget {
  const ToggleButtonTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PreferenceNotifier>().preference;

    final theme = prefs?.theme;

    return ToggleButtons(
      borderRadius: BorderRadius.circular(2.space),
      isSelected: [
        theme == 'light',
        theme == 'dark',
        theme == null,
      ],
      onPressed: (int index) {
        switch (index) {
          case 0:
            context.read<PreferenceNotifier>().setTheme('light');
          case 1:
            context.read<PreferenceNotifier>().setTheme('dark');
          case 2:
            context.read<PreferenceNotifier>().setTheme(null);
        }
      },
      children: const [
        Icon(Icons.wb_sunny_outlined),
        Icon(Icons.nights_stay_outlined),
        Icon(Icons.brightness_6_outlined),
      ],
    );
  }
}
