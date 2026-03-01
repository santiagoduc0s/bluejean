import 'package:lune/data/services/services.dart';
import 'package:lune/domain/repositories/repositories.dart';

class SignOutUseCase {
  SignOutUseCase({
    required AuthRepository authRepository,
    required DeviceRepository deviceRepository,
    required DeviceInfoService deviceInfoService,
  }) : _authRepository = authRepository,
       _deviceRepository = deviceRepository,
       _deviceInfoService = deviceInfoService;

  final AuthRepository _authRepository;
  final DeviceRepository _deviceRepository;
  final DeviceInfoService _deviceInfoService;

  Future<void> call() async {
    final identifier = await _deviceInfoService.getDeviceId();
    await _deviceRepository.unlinkDevice(identifier);
    await _authRepository.signOut();
  }
}
