import 'package:lune/data/repositories/repositories.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providerRepositories = [
  // Auth Repository
  Provider<AuthRepository>(
    create: (context) => AuthRepositoryImpl(
      localStorageService: context.read(),
      apiClient: context.read(),
    ),
  ),

  // Device Repository
  Provider<DeviceRepository>(
    create: (context) => DeviceRepositoryImpl(
      deviceInfoService: context.read(),
      apiClient: context.read(),
    ),
  ),

  // Preference Repository
  Provider<PreferenceRepository>(
    create: (context) => PreferenceRepositoryImpl(
      deviceInfoService: context.read(),
      apiClient: context.read(),
    ),
  ),

  // Public Onboard Repository
  Provider<PublicOnboardRepository>(
    create: (context) => PublicOnboardRepositoryImpl(
      service: context.read(),
    ),
  ),

  // Permission Repository
  Provider<PermissionRepository>(
    create: (context) => PermissionRepositoryImpl(
      service: context.read(),
    ),
  ),

  // Messaging Repository
  Provider<MessagingRepository>(
    create: (context) => MessagingRepositoryImpl(),
  ),

  // Support Repository
  Provider<SupportRepository>(
    create: (context) => SupportRespositoryImpl(
      apiClient: context.read(),
    ),
  ),

  // Remote Storage Repository
  Provider<RemoteStorageRepository>(
    create: (context) => RemoteStorageRepositoryImpl(
      apiClient: context.read(),
    ),
  ),
];
