import 'package:lune/domain/usecases/auth/sign_up_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late SignUpUseCase useCase;

  setUp(() {
    authRepository = MockAuthRepository();
    useCase = SignUpUseCase(authRepository: authRepository);
  });

  test('delegates to authRepository.signUpWithEmailAndPassword', () async {
    when(
      () => authRepository.signUpWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await useCase(email: 'test@test.com', password: 'pass123');

    verify(
      () => authRepository.signUpWithEmailAndPassword(
        email: 'test@test.com',
        password: 'pass123',
      ),
    ).called(1);
  });

  test('propagates exception from repo', () async {
    when(
      () => authRepository.signUpWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(Exception('sign up error'));

    expect(
      () => useCase(email: 'test@test.com', password: 'pass123'),
      throwsA(isA<Exception>()),
    );
  });
}
