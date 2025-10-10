import 'package:lune/domain/repositories/repositories.dart';

class SignUpUseCase {
  SignUpUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<void> call({required String email, required String password}) async {
    await _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    /// create driver
  }
}
