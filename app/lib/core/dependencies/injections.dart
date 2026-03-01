import 'package:lune/core/ui/alerts/alerts.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/domain/usecases/usecases.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';
import 'package:lune/ui/preference/notifiers/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  /// CORE
  Provider(create: (_) => getIt<CustomDialog>()),
  Provider(create: (_) => getIt<Localization>()),

  /// SERVICES
  Provider(create: (_) => getIt<LocalStorageService>()),
  Provider(create: (_) => getIt<DeviceInfoService>()),

  /// REPOSITORIES
  Provider<AuthRepository>(create: (_) => getIt<AuthRepository>()),
  Provider<DeviceRepository>(
    create: (_) => getIt<DeviceRepository>(),
  ),
  Provider<PermissionRepository>(
    create: (_) => getIt<PermissionRepository>(),
  ),

  /// USE CASES
  Provider(create: (_) => getIt<SignInWithEmailPasswordUseCase>()),
  Provider(create: (_) => getIt<SignUpUseCase>()),
  Provider(create: (_) => getIt<ForgotPasswordUseCase>()),
  Provider(create: (_) => getIt<UpdateCurrentUserUsecase>()),
  Provider(create: (_) => getIt<SignOutUseCase>()),
  Provider(create: (_) => getIt<DeleteAccountUsecase>()),
  Provider(create: (_) => getIt<SaveFcmTokenUseCase>()),

  /// GLOBAL NOTIFIERS
  ChangeNotifierProvider.value(value: getIt<AuthNotifier>()),
  ChangeNotifierProvider.value(value: getIt<PreferenceNotifier>()),

  /// ROUTER
  Provider(create: (_) => getIt<CustomRouter>()),
];
