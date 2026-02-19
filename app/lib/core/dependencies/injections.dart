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
  Provider.value(value: AppProvider.get<CustomDialog>()),
  Provider.value(value: AppProvider.get<CustomSnackbar>()),
  Provider.value(value: AppProvider.get<Localization>()),

  /// SERVICES
  Provider.value(value: AppProvider.get<LocalStorageService>()),
  Provider.value(value: AppProvider.get<PermissionService>()),
  Provider.value(value: AppProvider.get<DeviceInfoService>()),
  Provider.value(value: AppProvider.get<ApiClient>()),

  /// REPOSITORIES
  Provider.value(value: AppProvider.get<AuthRepository>()),
  Provider.value(value: AppProvider.get<DeviceRepository>()),
  Provider.value(value: AppProvider.get<PreferenceRepository>()),
  Provider.value(value: AppProvider.get<PermissionRepository>()),
  Provider.value(value: AppProvider.get<MessagingRepository>()),
  Provider.value(value: AppProvider.get<SupportRepository>()),
  Provider.value(value: AppProvider.get<RemoteStorageRepository>()),

  /// USE CASES
  Provider.value(value: AppProvider.get<SignInWithEmailPasswordUseCase>()),
  Provider.value(value: AppProvider.get<SignUpUseCase>()),
  Provider.value(value: AppProvider.get<ForgotPasswordUseCase>()),
  Provider.value(value: AppProvider.get<UpdateCurrentUserUsecase>()),
  Provider.value(value: AppProvider.get<SignOutUseCase>()),
  Provider.value(value: AppProvider.get<DeleteAccountUsecase>()),
  Provider.value(value: AppProvider.get<SaveFcmTokenUseCase>()),
  Provider.value(value: AppProvider.get<OpenAppUseCase>()),

  /// GLOBAL NOTIFIERS
  ChangeNotifierProvider.value(value: AppProvider.get<AuthNotifier>()),
  ChangeNotifierProvider.value(value: AppProvider.get<PreferenceNotifier>()),

  /// ROUTER
  Provider.value(value: AppProvider.get<CustomRouter>()),
];
