import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';
import 'package:lune/core/ui/alerts/snackbar/snackbar.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/domain/usecases/auth/auth.dart';
import 'package:lune/domain/usecases/messaging/messaging.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';

class SettingsNotifier extends ChangeNotifier {
  SettingsNotifier({
    required void Function() onSignOut,
    required PermissionRepository permissionRepository,
    required SaveFcmTokenUseCase saveTokenUseCase,
    required CustomDialog dialog,
    required CustomSnackbar snackbar,
    required Localization localization,
    required AuthNotifier authNotifier,
    required PreferenceRepository userPreferenceRepository,
    required SignOutUseCase signOutUseCase,
    required DeleteAccountUsecase deleteAccountUsecase,
  }) : _localization = localization,
       _snackbar = snackbar,
       _dialog = dialog,
       _saveTokenUseCase = saveTokenUseCase,
       _permissionRepository = permissionRepository,
       _onSignOut = onSignOut,
       _authNotifier = authNotifier,
       _userPreferenceRepository = userPreferenceRepository,
       _signOutUseCase = signOutUseCase,
       _deleteAccountUsecase = deleteAccountUsecase;

  final PermissionRepository _permissionRepository;
  final SaveFcmTokenUseCase _saveTokenUseCase;
  final CustomDialog _dialog;
  final CustomSnackbar _snackbar;
  final Localization _localization;
  final AuthNotifier _authNotifier;
  final PreferenceRepository _userPreferenceRepository;
  final SignOutUseCase _signOutUseCase;
  final DeleteAccountUsecase _deleteAccountUsecase;

  final void Function() _onSignOut;

  bool notificationsEnabled = false;
  bool isDeletingAccount = false;

  @override
  void dispose() {
    _authNotifier.removeListener(_authListener);
    super.dispose();
  }

  Future<void> initialize() async {
    _authNotifier.addListener(_authListener);
    await _authListener();
  }

  Future<void> _authListener() async {
    if (_authNotifier.isAuthenticated) {
      await checkNotificationPermission();
    }

    if (!kIsWeb) {
      unawaited(_saveTokenUseCase.call().catchError((_) {}));
    }
  }

  Future<void> checkNotificationPermission() async {
    final pref = await _userPreferenceRepository.getCurrentPreference();
    if (!kIsWeb) {
      final status = await _permissionRepository.check(
        PermissionType.notifications,
      );

      notificationsEnabled =
          pref.notificationsAreEnabled && status == PermissionStatus.granted;

      if (!hasListeners) return;

      notifyListeners();
    } else {
      notificationsEnabled = pref.notificationsAreEnabled;
    }
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final previousState = notificationsEnabled;

    try {
      if (value) {
        var status = await _permissionRepository.check(
          PermissionType.notifications,
        );

        if (status == PermissionStatus.permanentlyDenied) {
          final shouldOpenSettings = await dialogConfirm(
            _dialog,
            message: _localization.tr.notificationsAreDisabled,
            confirmText: _localization.tr.goToSettings,
            cancelText: _localization.tr.cancel,
          );
          if (shouldOpenSettings) {
            await _permissionRepository.openSettings();
          }
          notificationsEnabled = false;
        } else {
          notificationsEnabled = false;
        }

        if (status == PermissionStatus.denied) {
          final requestStatus = await _permissionRepository.request(
            PermissionType.notifications,
          );

          status = requestStatus;
        }

        if (status == PermissionStatus.granted) {
          notificationsEnabled = true;
          notifyListeners();

          await _saveTokenUseCase.call();
          await _userPreferenceRepository.updatePreference(
            notificationsAreEnabled: true,
          );
        }
      } else {
        notificationsEnabled = false;
        notifyListeners();

        if (previousState) {
          await _userPreferenceRepository.updatePreference(
            notificationsAreEnabled: false,
          );
        }
      }
    } catch (e, s) {
      notificationsEnabled = previousState;
      notifyListeners();
      logError(e, s);
      errorSnackbar(_snackbar, _localization.tr.generalError);
    }
  }

  Future<void> deleteAccount() async {
    if (isDeletingAccount) return;

    isDeletingAccount = true;
    notifyListeners();

    try {
      final shouldDelete = await dialogConfirm(
        _dialog,
        message: _localization.tr.deleteAccountMessage,
        confirmText: _localization.tr.yes,
        cancelText: _localization.tr.cancel,
      );

      if (!shouldDelete) return;

      await _deleteAccountUsecase.call();
      _onSignOut();
    } catch (e, s) {
      logError(e, s);
      errorSnackbar(_snackbar, _localization.tr.generalError);
    } finally {
      isDeletingAccount = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _signOutUseCase.call();
    _onSignOut();
  }
}
