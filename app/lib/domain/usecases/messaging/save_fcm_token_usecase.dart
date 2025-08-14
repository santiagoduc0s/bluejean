import 'package:lune/domain/repositories/repositories.dart';

class SaveFcmTokenUseCase {
  SaveFcmTokenUseCase({
    required MessagingRepository messagingRepository,
    required DeviceRepository deviceRepository,
  }) : _messagingRepository = messagingRepository,
       _deviceRepository = deviceRepository;

  final MessagingRepository _messagingRepository;
  final DeviceRepository _deviceRepository;

  Future<void> call() async {
    final fcmToken = await _messagingRepository.getFCMToken();

    if (fcmToken == null) return;

    await _deviceRepository.updateDevice(fcmToken: fcmToken);
  }
}
