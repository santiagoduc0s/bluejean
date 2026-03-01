import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class SignInWithEmailPasswordUseCase {
  SignInWithEmailPasswordUseCase({
    required AuthRepository authRepository,
    required DeviceRepository deviceRepository,
  }) : _authRepository = authRepository,
       _deviceRepository = deviceRepository;

  final AuthRepository _authRepository;
  final DeviceRepository _deviceRepository;

  Future<UserEntity?> call({
    required String email,
    required String password,
  }) async {
    await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _deviceRepository.upsertDevice();

    return _authRepository.currentUser();
  }
}
