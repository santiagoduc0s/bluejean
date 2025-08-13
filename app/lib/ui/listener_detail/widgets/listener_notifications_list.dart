import 'package:flutter/material.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/listener_detail/notifiers/listener_detail_notifier.dart';
import 'package:lune/ui/listener_detail/widgets/notification_tile.dart';
import 'package:provider/provider.dart';

class ListenerNotificationsList extends StatefulWidget {
  const ListenerNotificationsList({super.key});

  @override
  State<ListenerNotificationsList> createState() =>
      _ListenerNotificationsListState();
}

class _ListenerNotificationsListState extends State<ListenerNotificationsList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<ListenerDetailNotifier>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Consumer<ListenerDetailNotifier>(
      builder: (context, notifier, child) {
        if (notifier.isLoading && notifier.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (notifier.hasError && notifier.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.errorLoadingNotifications,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  notifier.errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: notifier.refresh,
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        if (notifier.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noNotificationsFound,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.notificationsWillAppearHere,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: notifier.refresh,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: notifier.notifications.length + 
                (notifier.hasMorePages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == notifier.notifications.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final notification = notifier.notifications[index];
              return NotificationTile(
                notification: notification,
                isLast: index == notifier.notifications.length - 1,
              );
            },
          ),
        );
      },
    );
  }
}
