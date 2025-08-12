import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/l10n/gen_l10n/app_localizations.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/channel/channel.dart';
import 'package:lune/ui/home/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeNotifier>().loadChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.5),
              colors.secondary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Consumer<HomeNotifier>(
          builder: (context, notifier, child) {
            if (notifier.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (notifier.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.errorPrefix(notifier.error!),
                      style: TextStyle(color: colors.error),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => notifier.loadChannels(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            }

            if (notifier.activeChannels.isEmpty &&
                notifier.inactiveChannels.isEmpty) {
              return Center(
                child: Text(l10n.noChannelsFound),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(top: paddingTop + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notifier.activeChannels.isNotEmpty) ...[
                    _buildSectionHeader(
                      l10n.activeChannels,
                      colors.primary,
                      subtitle: l10n.activeChannelsSubtitle,
                    ),
                    const SizedBox(height: 8),
                    ...notifier.activeChannels.map(
                      (channel) => _buildChannelCard(
                        context,
                        channel,
                        l10n,
                        isActive: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (notifier.inactiveChannels.isNotEmpty) ...[
                    _buildSectionHeader(
                      l10n.inactiveChannels,
                      colors.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 8),
                    ...notifier.inactiveChannels.map(
                      (channel) => _buildChannelCard(
                        context,
                        channel,
                        l10n,
                        isActive: false,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<HomeNotifier>(
            builder: (context, notifier, child) {
              return FloatingActionButton(
                heroTag: 'location',
                onPressed: () => notifier.toggleLocationTracking(),
                backgroundColor:
                    notifier.isLocationTracking ? colors.errorContainer : null,
                child: Icon(
                  notifier.isLocationTracking
                      ? Icons.location_off
                      : Icons.location_on,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _navigateToChannelForm(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToChannelForm(
    BuildContext context, {
    ChannelEntity? channel,
  }) async {
    final result =
        await context.pushNamed(ChannelFormScreen.path, extra: channel);

    if (result == true && context.mounted) {
      await context.read<HomeNotifier>().loadChannels();
    }
  }

  void _showDeleteChannelDialog(BuildContext context, ChannelEntity channel) {
    final l10n = context.l10n;
    final homeNotifier = context.read<HomeNotifier>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteChannel),
        content: Text(l10n.deleteChannelConfirmation(channel.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              homeNotifier.deleteChannel(channel.id);
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, {String? subtitle}) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurface.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChannelCard(
    BuildContext context,
    ChannelEntity channel,
    AppLocalizations l10n, {
    required bool isActive,
  }) {
    final colors = context.colors;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: isActive
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.6),
        ),
        title: Text(
          channel.name,
          style: TextStyle(
            color: isActive
                ? colors.onSurface
                : colors.onSurface.withValues(alpha: 0.7),
          ),
        ),
        subtitle: channel.description != null
            ? Text(
                channel.description!,
                style: TextStyle(
                  color: isActive
                      ? colors.onSurface.withValues(alpha: 0.7)
                      : colors.onSurface.withValues(alpha: 0.5),
                ),
              )
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _navigateToChannelForm(context, channel: channel);
            } else if (value == 'delete') {
              _showDeleteChannelDialog(context, channel);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text(l10n.edit),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(l10n.delete),
            ),
          ],
        ),
      ),
    );
  }
}
