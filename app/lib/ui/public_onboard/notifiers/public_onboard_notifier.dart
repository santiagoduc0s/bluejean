import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/home/home.dart';

class PublicOnboardNotifier extends ChangeNotifier {
  PublicOnboardNotifier({
    required this.localStorageService,
    required this.router,
  });

  LocalStorageService localStorageService;

  CustomRouter router;

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
      errorSnackbar(localization.generalError);
      logError(e, s);
    } finally {
      _setLoading(false);
    }
  }
}
