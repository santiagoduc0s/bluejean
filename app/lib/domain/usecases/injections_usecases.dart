import 'package:lune/domain/usecases/usecases.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providerUseCases = [
  // Auth Use Cases
  ...[
    Provider<SignInWithEmailPasswordUseCase>(
      create: (context) => SignInWithEmailPasswordUseCase(
        authRepository: context.read(),
        deviceRepository: context.read(),
        userPreferenceRepository: context.read(),
      ),
    ),
    Provider<SignInWithAppleUseCase>(
      create: (context) => SignInWithAppleUseCase(
        authRepository: context.read(),
        deviceRepository: context.read(),
        userPreferenceRepository: context.read(),
      ),
    ),
    Provider<SignInWithGoogleUseCase>(
      create: (context) => SignInWithGoogleUseCase(
        authRepository: context.read(),
        deviceRepository: context.read(),
        userPreferenceRepository: context.read(),
      ),
    ),
    Provider<SignUpUseCase>(
      create: (context) => SignUpUseCase(
        authRepository: context.read(),
      ),
    ),
    Provider<ForgotPasswordUseCase>(
      create: (context) => ForgotPasswordUseCase(
        context.read(),
      ),
    ),
    Provider<UpdateCurrentUserUsecase>(
      create: (context) => UpdateCurrentUserUsecase(
        authRepository: context.read(),
        remoteStorageRepository: context.read(),
      ),
    ),
    Provider<SignOutUseCase>(
      create: (context) => SignOutUseCase(
        deviceRepository: context.read(),
        authRepository: context.read(),
      ),
    ),
    Provider<DeleteAccountUsecase>(
      create: (context) => DeleteAccountUsecase(
        authRepository: context.read(),
      ),
    ),
  ],

  // Messaging Use Cases
  ...[
    Provider<SaveFcmTokenUseCase>(
      create: (context) => SaveFcmTokenUseCase(
        messagingRepository: context.read(),
        deviceRepository: context.read(),
      ),
    ),
  ],

  // Lifecycle Use Cases
  ...[
    Provider<OpenAppUseCase>(
      create: (context) => OpenAppUseCase(
        deviceRepository: context.read(),
        preferenceRepository: context.read(),
        authRepository: context.read(),
        messagingRepository: context.read(),
      ),
    ),
  ],
];
