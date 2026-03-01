import 'package:flutter/foundation.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/domain/usecases/usecases.dart';

class DevicesNotifier extends ChangeNotifier with NotifierEffects {
  DevicesNotifier({
    required DeviceRepository deviceRepository,
    required SignOutUseCase signOutUseCase,
    required void Function() onSignOut,
  }) : _deviceRepository = deviceRepository,
       _signOutUseCase = signOutUseCase,
       _onSignOut = onSignOut;

  final DeviceRepository _deviceRepository;
  final SignOutUseCase _signOutUseCase;
  final void Function() _onSignOut;

  List<DeviceEntity> _devices = [];
  List<DeviceEntity> get devices => _devices;

  String? _currentIdentifier;
  String? get currentIdentifier => _currentIdentifier;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadDevices() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _devices = await _deviceRepository.getDevices();
      _currentIdentifier = await _deviceRepository.getDeviceIdentifier();
    } catch (e, s) {
      AppLoggerHelper.error(e.toString(), stackTrace: s);
      emitErrorSnackbar((l10n) => l10n.generalError);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDevice(int deviceId) async {
    try {
      final device = _devices.firstWhere((d) => d.id == deviceId);
      final isCurrentDevice = device.identifier == _currentIdentifier;

      if (isCurrentDevice) {
        await _signOutUseCase.call();
        _onSignOut();
      } else {
        await _deviceRepository.unlinkDevice(device.identifier);
      }

      _devices.removeWhere((device) => device.id == deviceId);
      notifyListeners();

      emitPrimarySnackbar((l10n) => l10n.deviceDeletedSuccessfully);
    } catch (e, s) {
      AppLoggerHelper.error(e.toString(), stackTrace: s);
      emitErrorSnackbar((l10n) => l10n.generalError);
    }
  }
}
