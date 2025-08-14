import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lune/domain/entities/listener_notification_entity.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    this.isLast = false,
    super.key,
  });

  final ListenerNotificationEntity notification;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');

    return Card(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTypeColor(context, notification.type),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTypeIcon(notification.type),
                    size: 20,
                    color: _getTypeIconColor(context, notification.type),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dateFormat.format(notification.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'go-outside':
        return Icons.directions_bus;
      case 'emergency':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getTypeColor(BuildContext context, String type) {
    final theme = Theme.of(context);
    switch (type) {
      case 'go-outside':
        return theme.colorScheme.primaryContainer;
      case 'emergency':
        return theme.colorScheme.errorContainer;
      case 'info':
        return theme.colorScheme.surfaceContainerHighest;
      default:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  Color _getTypeIconColor(BuildContext context, String type) {
    final theme = Theme.of(context);
    switch (type) {
      case 'go-outside':
        return theme.colorScheme.onPrimaryContainer;
      case 'emergency':
        return theme.colorScheme.onErrorContainer;
      case 'info':
        return theme.colorScheme.onSurface;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}
