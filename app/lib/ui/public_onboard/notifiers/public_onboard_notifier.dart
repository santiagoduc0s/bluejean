import 'package:flutter/material.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/home/home.dart';

class PublicOnboardNotifier extends ChangeNotifier with NotifierEffects {
  PublicOnboardNotifier({
    required this.preferenceRepository,
    required this.router,
  });

  PreferenceRepository preferenceRepository;

  CustomRouter router;

  late PublicOnboardStatus status;

  bool isLoading = false;

  Future<void> initialize() async {
    status = await preferenceRepository.getPOStatus();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> finishOnboard() async {
    _setLoading(true);

    try {
      await preferenceRepository.setPOStatus(PublicOnboardStatus.seen);

      router.goNamed(HomeScreen.path);
    } catch (e, s) {
      emitErrorSnackbar((l10n) => l10n.generalError);
      AppLoggerHelper.error(e.toString(), stackTrace: s);
    } finally {
      _setLoading(false);
    }
  }
}
