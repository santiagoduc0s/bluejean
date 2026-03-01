import 'package:lune/domain/repositories/repositories.dart';

class DeleteAccountUseCase {
  DeleteAccountUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<void> call() async {
    await _authRepository.deleteUser();
    await _authRepository.signOut().catchError((_) {});
  }
}
