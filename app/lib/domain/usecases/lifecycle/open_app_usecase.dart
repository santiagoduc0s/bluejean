import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class OpenAppUseCase {
  OpenAppUseCase({
    required DeviceRepository deviceRepository,
    required AuthRepository authRepository,
    required MessagingRepository messagingRepository,
  }) : _deviceRepository = deviceRepository,
       _authRepository = authRepository,
       _messagingRepository = messagingRepository;

  final DeviceRepository _deviceRepository;
  final AuthRepository _authRepository;
  final MessagingRepository _messagingRepository;

  Future<UserEntity?> call() async {
    final user = await _authRepository.currentUser();

    final token = await _messagingRepository.getFCMToken();

    if (user != null) {
      await _deviceRepository.upsertDevice(fcmToken: token);
    }

    return user;
  }
}
