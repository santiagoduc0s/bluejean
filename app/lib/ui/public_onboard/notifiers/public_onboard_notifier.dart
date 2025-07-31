import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/alerts/snackbar/snackbar.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/usecases/public_onboard/public_onboard.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/home/home.dart';

class PublicOnboardNotifier extends ChangeNotifier {
  PublicOnboardNotifier({
    required this.setStatusUseCase,
    required this.getStatusUseCase,
    required this.router,
    required this.snackbar,
    required this.localization,
  });

  SetPublicOnboardStatusUseCase setStatusUseCase;
  GetPublicOnboardStatusUseCase getStatusUseCase;

  CustomRouter router;
  CustomSnackbar snackbar;
  Localization localization;

  late PublicOnboardStatus status;

  bool isLoading = false;

  Future<void> initialize() async {
    status = await getStatusUseCase.call();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> finishOnboard() async {
    _setLoading(true);

    try {
      await setStatusUseCase.call(PublicOnboardStatus.seen);

      router.goNamed(HomeScreen.path);
    } catch (e, s) {
      errorSnackbar(snackbar, localization.tr.generalError);
      logError(e, s);
    } finally {
      _setLoading(false);
    }
  }
}
