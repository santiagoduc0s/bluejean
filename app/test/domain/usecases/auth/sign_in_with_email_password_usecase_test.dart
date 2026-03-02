import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/usecases/auth/sign_in_with_email_password_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockDeviceRepository deviceRepository;
  late SignInWithEmailPasswordUseCase useCase;

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
    useCase = SignInWithEmailPasswordUseCase(
      authRepository: authRepository,
      deviceRepository: deviceRepository,
    );
  });

  test('signs in, upserts device, and returns current user', () async {
    when(
      () => authRepository.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    when(() => deviceRepository.upsertDevice()).thenAnswer(
      (_) async => tDevice,
    );
    when(() => authRepository.currentUser()).thenAnswer((_) async => tUser);

    final result = await useCase(email: 'test@test.com', password: 'pass');

    expect(result, tUser);
    verifyInOrder([
      () => authRepository.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'pass',
      ),
      () => deviceRepository.upsertDevice(),
      () => authRepository.currentUser(),
    ]);
  });

  test('propagates auth exception and does not call upsertDevice', () async {
    when(
      () => authRepository.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(Exception('auth error'));

    expect(
      () => useCase(email: 'test@test.com', password: 'pass'),
      throwsA(isA<Exception>()),
    );
    verifyNever(() => deviceRepository.upsertDevice());
  });

  test('propagates upsertDevice exception and does not call currentUser',
      () async {
    when(
      () => authRepository.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    when(() => deviceRepository.upsertDevice()).thenThrow(
      Exception('device error'),
    );

    expect(
      () => useCase(email: 'test@test.com', password: 'pass'),
      throwsA(isA<Exception>()),
    );
    verifyNever(() => authRepository.currentUser());
  });
}
