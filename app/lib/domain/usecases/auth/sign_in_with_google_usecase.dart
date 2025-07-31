import 'package:lune/domain/repositories/repositories.dart';

class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase({
    required AuthRepository authRepository,
    required DeviceRepository deviceRepository,
    required PreferenceRepository userPreferenceRepository,
  })  : _authRepository = authRepository,
        _deviceRepository = deviceRepository,
        _userPreferenceRepository = userPreferenceRepository;

  final AuthRepository _authRepository;
  final DeviceRepository _deviceRepository;
  final PreferenceRepository _userPreferenceRepository;

  Future<Map<String, dynamic>> call() async {
    await _authRepository.signInWithGoogle();

    await _deviceRepository.linkDevice();

    final user = await _authRepository.currentUser();
    final preference = await _userPreferenceRepository.getCurrentPreference();

    return {
      'user': user,
      'preference': preference,
    };
  }
}
