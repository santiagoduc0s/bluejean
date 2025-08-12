import 'package:flutter/foundation.dart';
import 'package:lune/core/config/config.dart';
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
  Provider.value(
    value: AppDialog(
      () => AppGlobalKey.getRootContext()!,
    ) as CustomDialog,
  ),
  Provider.value(
    value: AppSnackbar(
      () => AppGlobalKey.getScaffoldMessengerState()!,
    ) as CustomSnackbar,
  ),
  Provider.value(
    value: Localization(
      () => AppGlobalKey.getRootContext()!,
    ),
  ),

  /// SERVICES
  Provider.value(
    value: LocalStorageService(),
  ),
  Provider.value(
    value: PermissionService(),
  ),
  Provider.value(
    value: DeviceInfoService(),
  ),
  Provider.value(
    value: LocationTrackingService(
      permissionService: PermissionService(),
    ),
  ),
  Provider.value(
    value: ApiClient(
      baseUrl: Env.baseUrl,
      enableLogging: kDebugMode,
    ),
  ),

  /// REPOSITORIES
  ...providerRepositories,

  /// USE CASES
  ...providerUseCases,

  /// GLOBAL NOTIFIERS
  ChangeNotifierProvider(
    create: (context) => AuthNotifier(),
  ),
  ChangeNotifierProvider(
    create: (context) => PreferenceNotifier(
      userPreferenceRepository: context.read(),
    ),
  ),

  /// ROUTER
  Provider(
    create: (context) => AppGoRouter(
      context.read(),
    ) as CustomRouter,
  ),
];
