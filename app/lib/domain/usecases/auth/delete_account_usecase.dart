import 'package:lune/domain/repositories/repositories.dart';

class DeleteAccountUsecase {
  DeleteAccountUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<void> call() async {
    await _authRepository.deleteUser();
    await _authRepository.signOut().catchError((_) {});
  }
}
