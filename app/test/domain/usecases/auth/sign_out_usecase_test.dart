import 'package:lune/domain/usecases/auth/sign_out_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockDeviceRepository deviceRepository;
  late SignOutUseCase useCase;

  setUp(() {
    authRepository = MockAuthRepository();
    deviceRepository = MockDeviceRepository();
    useCase = SignOutUseCase(
      authRepository: authRepository,
      deviceRepository: deviceRepository,
    );
  });

  test('gets device identifier, unlinks device, then signs out in order',
      () async {
    when(() => deviceRepository.getDeviceIdentifier()).thenAnswer(
      (_) async => 'device-123',
    );
    when(() => deviceRepository.unlinkDevice(any())).thenAnswer(
      (_) async {},
    );
    when(() => authRepository.signOut()).thenAnswer((_) async {});

    await useCase();

    verifyInOrder([
      () => deviceRepository.getDeviceIdentifier(),
      () => deviceRepository.unlinkDevice('device-123'),
      () => authRepository.signOut(),
    ]);
  });

  test('propagates unlinkDevice error', () async {
    when(() => deviceRepository.getDeviceIdentifier()).thenAnswer(
      (_) async => 'device-123',
    );
    when(() => deviceRepository.unlinkDevice(any())).thenThrow(
      Exception('unlink error'),
    );

    expect(() => useCase(), throwsA(isA<Exception>()));
    verifyNever(() => authRepository.signOut());
  });
}
