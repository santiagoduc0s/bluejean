import 'package:flutter/foundation.dart';
import 'package:lune/core/extensions/change_notifier_extension.dart';
import 'package:lune/core/ui/ui.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/domain/usecases/usecases.dart';

class DevicesNotifier extends ChangeNotifier {
  DevicesNotifier({
    required DeviceRepository deviceRepository,
    required SignOutUseCase signOutUseCase,
    required CustomSnackbar snackbar,
    required Localization localization,
    required void Function() onSignOut,
  })  : _deviceRepository = deviceRepository,
        _signOutUseCase = signOutUseCase,
        _snackbar = snackbar,
        _localization = localization,
        _onSignOut = onSignOut;

  final DeviceRepository _deviceRepository;
  final SignOutUseCase _signOutUseCase;
  final CustomSnackbar _snackbar;
  final Localization _localization;
  final void Function() _onSignOut;

  List<DeviceEntity> _devices = [];
  List<DeviceEntity> get devices => _devices;

  DeviceEntity? _currentDevice;
  DeviceEntity? get currentDevice => _currentDevice;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadDevices() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _devices = await _deviceRepository.getDevices();
      _currentDevice = await _deviceRepository.getCurrentDevice();
    } catch (e, s) {
      logError(e, s);
      errorSnackbar(_snackbar, _localization.tr.generalError);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDevice(int deviceId) async {
    try {
      final device = _devices.firstWhere((d) => d.id == deviceId);
      final isCurrentDevice = _currentDevice?.id == deviceId;

      if (isCurrentDevice) {
        await _signOutUseCase.call();
        _onSignOut();
      } else {
        await _deviceRepository.unlinkDevice(device.identifier);
      }

      _devices.removeWhere((device) => device.id == deviceId);
      notifyListeners();

      primarySnackbar(
        _snackbar,
        'Device deleted successfully',
      );
    } catch (e, s) {
      logError(e, s);
      errorSnackbar(_snackbar, _localization.tr.generalError);
    }
  }
}
