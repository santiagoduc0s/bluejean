// ignore_for_file: cascade_invocations, unnecessary_lambdas

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:lune/core/config/config.dart';
import 'package:lune/core/ui/alerts/alerts.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/repositories/repositories.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/domain/usecases/usecases.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';
import 'package:lune/ui/preference/notifiers/notifiers.dart';

final getIt = GetIt.instance;

bool _isInitialized = false;

void initServiceLocator() {
  if (_isInitialized) return;

  // CORE
  getIt.registerLazySingleton<CustomDialog>(
    () => AppDialog(() => AppGlobalKey.getRootContext()!),
  );
  getIt.registerLazySingleton<CustomSnackbar>(
    () => AppSnackbar(() => AppGlobalKey.getScaffoldMessengerState()!),
  );
  getIt.registerLazySingleton(
    () => Localization(() => AppGlobalKey.getRootContext()!),
  );

  // SERVICES
  getIt.registerLazySingleton(() => LocalStorageService());
  getIt.registerLazySingleton(() => DeviceInfoService());
  getIt.registerLazySingleton(
    () => ApiClient(
      baseUrl: Env.baseUrl,
      enableLogging: kDebugMode,
      onUnauthorized: () {
        getIt<AuthNotifier>().signOut();
        getIt<AuthRepository>().clearSession();
      },
      isAuthenticated: () => getIt<AuthRepository>().isAuthenticated(),
      getAccessToken: () => getIt<AuthRepository>().accessToken,
    ),
  );

  // REPOSITORIES
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localStorageService: getIt<LocalStorageService>(),
      apiClient: getIt<ApiClient>(),
    ),
  );
  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      deviceInfoService: getIt<DeviceInfoService>(),
      apiClient: getIt<ApiClient>(),
    ),
  );
  getIt.registerLazySingleton<PermissionRepository>(
    () => PermissionRepositoryImpl(),
  );
  getIt.registerLazySingleton<MessagingRepository>(
    () => MessagingRepositoryImpl(),
  );
  getIt.registerLazySingleton<PreferenceRepository>(
    () => PreferenceRepositoryImpl(
      localStorageService: getIt<LocalStorageService>(),
    ),
  );
getIt.registerLazySingleton<RemoteStorageRepository>(
    () => RemoteStorageRepositoryImpl(apiClient: getIt<ApiClient>()),
  );

  // USE CASES
  getIt.registerLazySingleton(
    () => SignInWithEmailPasswordUseCase(
      authRepository: getIt<AuthRepository>(),
      deviceRepository: getIt<DeviceRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignUpUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ForgotPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateCurrentUserUseCase(
      authRepository: getIt<AuthRepository>(),
      remoteStorageRepository: getIt<RemoteStorageRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignOutUseCase(
      deviceRepository: getIt<DeviceRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DeleteAccountUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => SaveFcmTokenUseCase(
      messagingRepository: getIt<MessagingRepository>(),
      deviceRepository: getIt<DeviceRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => OpenAppUseCase(
      deviceRepository: getIt<DeviceRepository>(),
      authRepository: getIt<AuthRepository>(),
      messagingRepository: getIt<MessagingRepository>(),
    ),
  );

  // GLOBAL NOTIFIERS
  getIt.registerLazySingleton(() => AuthNotifier());
  getIt.registerLazySingleton(
    () => PreferenceNotifier(
      preferenceRepository: getIt<PreferenceRepository>(),
    ),
  );

  // ROUTER
  getIt.registerLazySingleton<CustomRouter>(
    () => AppGoRouter(getIt<AuthNotifier>()),
  );

  _isInitialized = true;
}
