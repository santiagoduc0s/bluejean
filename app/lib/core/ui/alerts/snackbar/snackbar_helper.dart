import 'package:flutter/material.dart';
import 'package:lune/core/ui/alerts/snackbar/snackbar.dart';
import 'package:lune/core/utils/utils.dart';

class SnackbarHelper {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> success(
    String message, {
    void Function()? onTap,
  }) {
    return AppProvider.get<CustomSnackbar>().show(
      PrimarySnackBar(text: message, onTap: onTap),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error(
    String message, {
    void Function()? onTap,
  }) {
    return AppProvider.get<CustomSnackbar>().show(
      ErrorSnackBar(text: message, onTap: onTap),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    SnackBar snackbar,
  ) {
    return AppProvider.get<CustomSnackbar>().show(snackbar);
  }
}
