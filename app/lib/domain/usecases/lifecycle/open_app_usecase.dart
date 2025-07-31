import 'package:lune/domain/repositories/repositories.dart';

class OpenAppUseCase {
  OpenAppUseCase({
    required DeviceRepository deviceRepository,
    required PreferenceRepository preferenceRepository,
    required AuthRepository authRepository,
    required MessagingRepository messagingRepository,
  })  : _deviceRepository = deviceRepository,
        _preferenceRepository = preferenceRepository,
        _authRepository = authRepository,
        _messagingRepository = messagingRepository;

  final DeviceRepository _deviceRepository;
  final PreferenceRepository _preferenceRepository;
  final AuthRepository _authRepository;
  final MessagingRepository _messagingRepository;

  Future<Map<String, dynamic>> call() async {
    // currentUser first because the respose could be a 401.
    final user = await _authRepository.currentUser();

    var device = await _deviceRepository.getCurrentDevice();

    device ??= await _deviceRepository.createDevice();

    final preference = await _preferenceRepository.getCurrentPreference();

    final token = await _messagingRepository.getFCMToken();

    await _deviceRepository.updateDevice(fcmToken: token);

    return {
      'device': device,
      'user': user,
      'preference': preference,
    };
  }
}
