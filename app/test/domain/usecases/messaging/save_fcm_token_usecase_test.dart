import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/usecases/messaging/save_fcm_token_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockMessagingRepository messagingRepository;
  late MockDeviceRepository deviceRepository;
  late SaveFcmTokenUseCase useCase;

  setUp(() {
    messagingRepository = MockMessagingRepository();
    deviceRepository = MockDeviceRepository();
    useCase = SaveFcmTokenUseCase(
      messagingRepository: messagingRepository,
      deviceRepository: deviceRepository,
    );
  });

  test('token exists: upserts device with token', () async {
    when(() => messagingRepository.getFCMToken()).thenAnswer(
      (_) async => 'fcm-token-123',
    );
    when(
      () => deviceRepository.upsertDevice(fcmToken: any(named: 'fcmToken')),
    ).thenAnswer(
      (_) async => DeviceEntity(
        id: 1,
        identifier: 'abc',
        model: 'iPhone',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      ),
    );

    await useCase();

    verify(
      () => deviceRepository.upsertDevice(fcmToken: 'fcm-token-123'),
    ).called(1);
  });

  test('token is null: returns early, does NOT call upsertDevice', () async {
    when(() => messagingRepository.getFCMToken()).thenAnswer(
      (_) async => null,
    );

    await useCase();

    verifyNever(
      () => deviceRepository.upsertDevice(fcmToken: any(named: 'fcmToken')),
    );
  });
}
