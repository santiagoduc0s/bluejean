import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/alerts/snackbar/snackbar.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/home/home.dart';

class PublicOnboardNotifier extends ChangeNotifier {
  PublicOnboardNotifier({
    required this.localStorageService,
    required this.router,
    required this.snackbar,
    required this.localization,
  });

  LocalStorageService localStorageService;

  CustomRouter router;
  CustomSnackbar snackbar;
  Localization localization;

  late PublicOnboardStatus status;

  bool isLoading = false;

  Future<void> initialize() async {
    status = await localStorageService.getPOStatus();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> finishOnboard() async {
    _setLoading(true);

    try {
      await localStorageService.setPOStatus(PublicOnboardStatus.seen);

      router.goNamed(HomeScreen.path);
    } catch (e, s) {
      errorSnackbar(snackbar, localization.tr.generalError);
      logError(e, s);
    } finally {
      _setLoading(false);
    }
  }
}
