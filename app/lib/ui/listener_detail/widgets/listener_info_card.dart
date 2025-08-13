import 'package:flutter/material.dart';
import 'package:lune/domain/entities/listener_entity.dart';

class ListenerInfoCard extends StatelessWidget {
  const ListenerInfoCard({
    required this.listener,
    super.key,
  });

  final ListenerEntity listener;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 30,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listener.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listener.phoneNumber,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (listener.address != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      listener.address!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: listener.status == 'active'
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                listener.status.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: listener.status == 'active'
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
