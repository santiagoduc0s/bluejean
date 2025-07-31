import 'package:flutter/material.dart';

abstract class CustomSnackbar {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    SnackBar snackbar,
  );
}
