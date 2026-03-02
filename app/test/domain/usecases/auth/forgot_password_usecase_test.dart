import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late ForgotPasswordUseCase useCase;

  setUp(() {
    authRepository = MockAuthRepository();
    useCase = ForgotPasswordUseCase(authRepository);
  });

  test('valid email calls repo', () async {
    when(
      () => authRepository.forgotPassword(
        email: any(named: 'email'),
        phone: any(named: 'phone'),
      ),
    ).thenAnswer((_) async {});

    await useCase(email: 'test@test.com');

    verify(
      () => authRepository.forgotPassword(email: 'test@test.com', phone: null),
    ).called(1);
  });

  test('valid phone calls repo', () async {
    when(
      () => authRepository.forgotPassword(
        email: any(named: 'email'),
        phone: any(named: 'phone'),
      ),
    ).thenAnswer((_) async {});

    await useCase(phone: '+1234567890');

    verify(
      () => authRepository.forgotPassword(email: null, phone: '+1234567890'),
    ).called(1);
  });

  test('both null throws ProvideAtLeastOneOfEmailOrPhoneException', () {
    expect(
      () => useCase(),
      throwsA(isA<ProvideAtLeastOneOfEmailOrPhoneException>()),
    );
  });

  test('both provided throws ProvideJustOneOfEmailOrPhoneException', () {
    expect(
      () => useCase(email: 'test@test.com', phone: '+1234567890'),
      throwsA(isA<ProvideJustOneOfEmailOrPhoneException>()),
    );
  });

  test('invalid email format throws InvalidEmailException', () {
    expect(
      () => useCase(email: 'invalid'),
      throwsA(isA<InvalidEmailException>()),
    );
  });

  test('invalid phone format throws InvalidPhoneNumberException', () {
    expect(
      () => useCase(phone: 'abc'),
      throwsA(isA<InvalidPhoneNumberException>()),
    );
  });

  test('valid E.164 phone without + calls repo', () async {
    when(
      () => authRepository.forgotPassword(
        email: any(named: 'email'),
        phone: any(named: 'phone'),
      ),
    ).thenAnswer((_) async {});

    await useCase(phone: '1234567890');

    verify(
      () => authRepository.forgotPassword(email: null, phone: '1234567890'),
    ).called(1);
  });

  test('valid E.164 phone with + calls repo', () async {
    when(
      () => authRepository.forgotPassword(
        email: any(named: 'email'),
        phone: any(named: 'phone'),
      ),
    ).thenAnswer((_) async {});

    await useCase(phone: '+441234567890');

    verify(
      () => authRepository.forgotPassword(
        email: null,
        phone: '+441234567890',
      ),
    ).called(1);
  });
}
