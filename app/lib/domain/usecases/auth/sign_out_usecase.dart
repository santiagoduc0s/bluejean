import 'package:lune/domain/repositories/repositories.dart';

class SignOutUseCase {
  SignOutUseCase({
    required AuthRepository authRepository,
    required DeviceRepository deviceRepository,
  }) : _authRepository = authRepository,
       _deviceRepository = deviceRepository;

  final AuthRepository _authRepository;
  final DeviceRepository _deviceRepository;

  Future<void> call() async {
    final identifier = await _deviceRepository.getDeviceIdentifier();
    await _deviceRepository.unlinkDevice(identifier);
    await _authRepository.signOut();
  }
}
