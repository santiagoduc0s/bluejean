import 'package:lune/domain/usecases/auth/delete_account_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late DeleteAccountUseCase useCase;

  setUp(() {
    authRepository = MockAuthRepository();
    useCase = DeleteAccountUseCase(authRepository: authRepository);
  });

  test('deletes user then signs out', () async {
    when(() => authRepository.deleteUser()).thenAnswer((_) async {});
    when(() => authRepository.signOut()).thenAnswer((_) async {});

    await useCase();

    verifyInOrder([
      () => authRepository.deleteUser(),
      () => authRepository.signOut(),
    ]);
  });

  test('signOut error is swallowed', () async {
    when(() => authRepository.deleteUser()).thenAnswer((_) async {});
    when(() => authRepository.signOut()).thenAnswer(
      (_) async => throw Exception('sign out error'),
    );

    // Should not throw despite signOut failing
    await useCase();

    verify(() => authRepository.deleteUser()).called(1);
    verify(() => authRepository.signOut()).called(1);
  });
}
