import 'package:flutter/material.dart';
import 'package:lune/domain/entities/listener_entity.dart';
import 'package:lune/domain/repositories/listener_notification_repository.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/listener_detail/notifiers/listener_detail_notifier.dart';
import 'package:lune/ui/listener_detail/widgets/listener_info_card.dart';
import 'package:lune/ui/listener_detail/widgets/listener_notifications_list.dart';
import 'package:provider/provider.dart';

class ListenerDetailPage extends StatelessWidget {
  const ListenerDetailPage({
    required this.listener,
    super.key,
  });

  final ListenerEntity listener;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ChangeNotifierProvider(
      create: (context) => ListenerDetailNotifier(
        listenerNotificationRepository:
            context.read<ListenerNotificationRepository>(),
        listener: listener,
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Listener Info Card
            ListenerInfoCard(listener: listener),

            // Tab Bar
            TabBar(
              tabs: [
                Tab(
                  icon: const Icon(Icons.info_outline),
                  text: l10n.information,
                ),
                Tab(
                  icon: const Icon(Icons.notifications_outlined),
                  text: l10n.notifications,
                ),
              ],
            ),

            // Tab Views
            const Expanded(
              child: TabBarView(
                children: [
                  _InfoTab(),
                  ListenerNotificationsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  const _InfoTab();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final listener = context.read<ListenerDetailNotifier>().listener;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.person,
            label: l10n.name,
            value: listener.name,
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.phone,
            label: l10n.phoneNumber,
            value: listener.phoneNumber,
          ),
          const SizedBox(height: 16),
          if (listener.address != null)
            _InfoRow(
              icon: Icons.location_on,
              label: l10n.address,
              value: listener.address!,
            ),
          if (listener.address != null) const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.adjust,
            label: l10n.threshold,
            value: '${listener.thresholdMeters} m',
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.circle,
            label: l10n.status,
            value: listener.status,
            valueColor: listener.status == 'active'
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
          if (listener.latitude != null && listener.longitude != null) ...[
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.my_location,
              label: l10n.coordinates,
              value: '${listener.latitude!.toStringAsFixed(6)}, '
                  '${listener.longitude!.toStringAsFixed(6)}',
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
