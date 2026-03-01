import 'package:flutter/material.dart';
import 'package:lune/core/ui/spacing/ui_spacing.dart';

class AppInputStyles {
  AppInputStyles({required this.colorScheme});

  final ColorScheme colorScheme;

  InputDecoration get primary => InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
      borderRadius: BorderRadius.circular(3.space),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.primary),
      borderRadius: BorderRadius.circular(3.space),
    ),
  );
}
