import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/usecases/lifecycle/open_app_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockDeviceRepository deviceRepository;
  late MockMessagingRepository messagingRepository;
  late OpenAppUseCase useCase;

  final tUser = UserEntity(
    id: 1,
    name: 'Test',
    email: 'test@test.com',
    photo: null,
    updatedAt: DateTime(2024),
    createdAt: DateTime(2024),
  );

  final tDevice = DeviceEntity(
    id: 1,
    identifier: 'abc',
    model: 'iPhone',
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  setUp(() {
    authRepository = MockAuthRepository();
    deviceRepository = MockDeviceRepository();
    messagingRepository = MockMessagingRepository();
    useCase = OpenAppUseCase(
      authRepository: authRepository,
      deviceRepository: deviceRepository,
      messagingRepository: messagingRepository,
    );
  });

  test(
    'authenticated user: gets user, gets token, upserts device, returns user',
    () async {
      when(() => authRepository.currentUser()).thenAnswer(
        (_) async => tUser,
      );
      when(() => messagingRepository.getFCMToken()).thenAnswer(
        (_) async => 'fcm-token-123',
      );
      when(
        () => deviceRepository.upsertDevice(fcmToken: any(named: 'fcmToken')),
      ).thenAnswer((_) async => tDevice);

      final result = await useCase();

      expect(result, tUser);
      verify(
        () => deviceRepository.upsertDevice(fcmToken: 'fcm-token-123'),
      ).called(1);
    },
  );

  test(
    'no user (null): gets token but does NOT upsert device, returns null',
    () async {
      when(() => authRepository.currentUser()).thenAnswer((_) async => null);
      when(() => messagingRepository.getFCMToken()).thenAnswer(
        (_) async => 'fcm-token-123',
      );

      final result = await useCase();

      expect(result, isNull);
      verifyNever(
        () => deviceRepository.upsertDevice(fcmToken: any(named: 'fcmToken')),
      );
    },
  );

  test(
    'token is null: still upserts device with null token if user exists',
    () async {
      when(() => authRepository.currentUser()).thenAnswer(
        (_) async => tUser,
      );
      when(() => messagingRepository.getFCMToken()).thenAnswer(
        (_) async => null,
      );
      when(
        () => deviceRepository.upsertDevice(fcmToken: any(named: 'fcmToken')),
      ).thenAnswer((_) async => tDevice);

      final result = await useCase();

      expect(result, tUser);
      verify(() => deviceRepository.upsertDevice(fcmToken: null)).called(1);
    },
  );
}
