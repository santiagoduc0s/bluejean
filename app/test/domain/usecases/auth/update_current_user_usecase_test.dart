import 'dart:typed_data';

import 'package:lune/core/utils/nullable_parameter.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/usecases/auth/update_current_user_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockRemoteStorageRepository remoteStorageRepository;
  late UpdateCurrentUserUseCase useCase;

  final tUser = UserEntity(
    id: 1,
    name: 'Updated',
    email: 'new@test.com',
    photo: null,
    updatedAt: DateTime(2024),
    createdAt: DateTime(2024),
  );

  setUpAll(registerFallbackValues);

  setUp(() {
    authRepository = MockAuthRepository();
    remoteStorageRepository = MockRemoteStorageRepository();
    useCase = UpdateCurrentUserUseCase(
      authRepository: authRepository,
      remoteStorageRepository: remoteStorageRepository,
    );
  });

  test('name/email only calls updateCurrentUser without upload', () async {
    when(
      () => authRepository.updateCurrentUser(
        name: any(named: 'name'),
        email: any(named: 'email'),
        photo: any(named: 'photo'),
      ),
    ).thenAnswer((_) async => tUser);

    final result = await useCase(name: 'Updated', email: 'new@test.com');

    expect(result, tUser);
    verifyNever(
      () => remoteStorageRepository.uploadFile(
        data: any(named: 'data'),
        path: any(named: 'path'),
      ),
    );
    verify(
      () => authRepository.updateCurrentUser(
        name: 'Updated',
        email: 'new@test.com',
        photo: any(named: 'photo'),
      ),
    ).called(1);
  });

  test('with photo bytes uploads file first, passes URL to updateCurrentUser',
      () async {
    final photoBytes = Uint8List.fromList([1, 2, 3]);

    when(
      () => remoteStorageRepository.uploadFile(
        data: any(named: 'data'),
        path: any(named: 'path'),
      ),
    ).thenAnswer((_) async => 'https://cdn.example.com/photo.jpg');
    when(
      () => authRepository.updateCurrentUser(
        name: any(named: 'name'),
        email: any(named: 'email'),
        photo: any(named: 'photo'),
      ),
    ).thenAnswer((_) async => tUser);

    await useCase(photo: NullableParameter(photoBytes));

    verify(
      () => remoteStorageRepository.uploadFile(
        data: photoBytes,
        path: '/profile',
      ),
    ).called(1);

    final captured = verify(
      () => authRepository.updateCurrentUser(
        name: null,
        email: null,
        photo: captureAny(named: 'photo'),
      ),
    ).captured.single as NullableParameter<String?>;
    expect(captured.value, 'https://cdn.example.com/photo.jpg');
  });

  test(
    'photo is NullableParameter(null) skips upload, '
    'passes NullableParameter(null)',
    () async {
      when(
        () => authRepository.updateCurrentUser(
          name: any(named: 'name'),
          email: any(named: 'email'),
          photo: any(named: 'photo'),
        ),
      ).thenAnswer((_) async => tUser);

      await useCase(photo: NullableParameter(null));

      verifyNever(
        () => remoteStorageRepository.uploadFile(
          data: any(named: 'data'),
          path: any(named: 'path'),
        ),
      );

      final captured = verify(
        () => authRepository.updateCurrentUser(
          name: null,
          email: null,
          photo: captureAny(named: 'photo'),
        ),
      ).captured.single as NullableParameter<String?>;
      expect(captured.value, isNull);
    },
  );

  test('upload fails propagates exception', () async {
    final photoBytes = Uint8List.fromList([1, 2, 3]);

    when(
      () => remoteStorageRepository.uploadFile(
        data: any(named: 'data'),
        path: any(named: 'path'),
      ),
    ).thenThrow(Exception('upload failed'));

    expect(
      () => useCase(photo: NullableParameter(photoBytes)),
      throwsA(isA<Exception>()),
    );
    verifyNever(
      () => authRepository.updateCurrentUser(
        name: any(named: 'name'),
        email: any(named: 'email'),
        photo: any(named: 'photo'),
      ),
    );
  });
}
