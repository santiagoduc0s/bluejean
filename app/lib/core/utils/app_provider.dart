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

class AppProvider {
  static final GetIt _getIt = GetIt.instance;
  static bool _isInitialized = false;

  static void init() {
    if (_isInitialized) return;

    // CORE
    _getIt.registerLazySingleton<CustomDialog>(
      () => AppDialog(() => AppGlobalKey.getRootContext()!),
    );
    _getIt.registerLazySingleton<CustomSnackbar>(
      () => AppSnackbar(() => AppGlobalKey.getScaffoldMessengerState()!),
    );
    _getIt.registerLazySingleton(
      () => Localization(() => AppGlobalKey.getRootContext()!),
    );

    // SERVICES
    _getIt.registerLazySingleton(() => LocalStorageService());
    _getIt.registerLazySingleton(() => PermissionService());
    _getIt.registerLazySingleton(() => DeviceInfoService());
    _getIt.registerLazySingleton(
      () => ApiClient(baseUrl: Env.baseUrl, enableLogging: kDebugMode),
    );

    // REPOSITORIES
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        localStorageService: get<LocalStorageService>(),
        apiClient: get<ApiClient>(),
      ),
    );
    _getIt.registerLazySingleton<DeviceRepository>(
      () => DeviceRepositoryImpl(
        deviceInfoService: get<DeviceInfoService>(),
        apiClient: get<ApiClient>(),
      ),
    );
    _getIt.registerLazySingleton<PreferenceRepository>(
      () => PreferenceRepositoryImpl(
        deviceInfoService: get<DeviceInfoService>(),
        apiClient: get<ApiClient>(),
      ),
    );
    _getIt.registerLazySingleton<PermissionRepository>(
      () => PermissionRepositoryImpl(service: get<PermissionService>()),
    );
    _getIt.registerLazySingleton<MessagingRepository>(
      () => MessagingRepositoryImpl(),
    );
    _getIt.registerLazySingleton<SupportRepository>(
      () => SupportRespositoryImpl(apiClient: get<ApiClient>()),
    );
    _getIt.registerLazySingleton<RemoteStorageRepository>(
      () => RemoteStorageRepositoryImpl(apiClient: get<ApiClient>()),
    );

    // USE CASES
    _getIt.registerLazySingleton(
      () => SignInWithEmailPasswordUseCase(
        authRepository: get<AuthRepository>(),
        deviceRepository: get<DeviceRepository>(),
        userPreferenceRepository: get<PreferenceRepository>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => SignInWithAppleUseCase(
        authRepository: get<AuthRepository>(),
        deviceRepository: get<DeviceRepository>(),
        userPreferenceRepository: get<PreferenceRepository>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => SignInWithGoogleUseCase(
        authRepository: get<AuthRepository>(),
        deviceRepository: get<DeviceRepository>(),
        userPreferenceRepository: get<PreferenceRepository>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => SignUpUseCase(authRepository: get<AuthRepository>()),
    );
    _getIt.registerLazySingleton(
      () => ForgotPasswordUseCase(get<AuthRepository>()),
    );
    _getIt.registerLazySingleton(
      () => UpdateCurrentUserUsecase(
        authRepository: get<AuthRepository>(),
        remoteStorageRepository: get<RemoteStorageRepository>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => SignOutUseCase(
        deviceRepository: get<DeviceRepository>(),
        authRepository: get<AuthRepository>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => DeleteAccountUsecase(authRepository: get<AuthRepository>()),
    );
    _getIt.registerLazySingleton(
      () => SaveFcmTokenUseCase(
        messagingRepository: get<MessagingRepository>(),
        deviceRepository: get<DeviceRepository>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => OpenAppUseCase(
        deviceRepository: get<DeviceRepository>(),
        preferenceRepository: get<PreferenceRepository>(),
        authRepository: get<AuthRepository>(),
        messagingRepository: get<MessagingRepository>(),
      ),
    );

    // GLOBAL NOTIFIERS
    _getIt.registerLazySingleton(() => AuthNotifier());
    _getIt.registerLazySingleton(
      () => PreferenceNotifier(
        userPreferenceRepository: get<PreferenceRepository>(),
      ),
    );

    // ROUTER
    _getIt.registerLazySingleton<CustomRouter>(
      () => AppGoRouter(get<AuthNotifier>()),
    );

    _isInitialized = true;
  }

  static T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
