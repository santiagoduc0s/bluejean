import 'package:go_router/go_router.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/ui/channel/notifiers/notifiers.dart';
import 'package:lune/ui/channel/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChannelFormScreen {
  const ChannelFormScreen();

  static const path = '/channel-form';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) {
      final channel = state.extra as ChannelEntity?;

      return ChangeNotifierProvider(
        create: (context) {
          final notifier = ChannelFormNotifier(
            channelRepository: context.read(),
            listenerRepository: context.read(),
            permissionService: context.read(),
            channel: channel,
          );

          if (channel != null) {
            notifier.loadListeners();
          }

          return notifier;
        },
        child: const ChannelFormPage(),
      );
    },
    routes: routes,
  );
}
