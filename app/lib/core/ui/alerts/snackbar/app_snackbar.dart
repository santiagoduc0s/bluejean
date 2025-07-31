import 'package:flutter/material.dart';
import 'package:lune/core/ui/alerts/snackbar/snackbar.dart';

class AppSnackbar extends CustomSnackbar {
  AppSnackbar(
    this.scaffoldMessenger,
  );

  final ScaffoldMessengerState Function() scaffoldMessenger;

  /// Shows a snackbar with the given [snackbar] content.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
    SnackBar snackbar,
  ) {
    final currentState = scaffoldMessenger()..hideCurrentSnackBar();

    return currentState.showSnackBar(snackbar);
  }

  @override
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    SnackBar snackbar,
  ) {
    return _showSnackBar(snackbar);
  }
}
