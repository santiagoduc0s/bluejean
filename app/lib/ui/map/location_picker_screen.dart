import 'package:go_router/go_router.dart';
import 'package:lune/ui/map/widgets/location_picker_page.dart';

class LocationPickerScreen {
  const LocationPickerScreen();

  static const path = '/location-picker';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final initialLatitude = extra?['latitude'] as double?;
      final initialLongitude = extra?['longitude'] as double?;
      final thresholdMeters = extra?['thresholdMeters'] as int?;

      return LocationPickerPage(
        initialLatitude: initialLatitude,
        initialLongitude: initialLongitude,
        thresholdMeters: thresholdMeters,
      );
    },
    routes: routes,
  );
}
