import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/domain/entities/entities.dart';
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

            if (notifier.channels.isEmpty) {
              return Center(
                child: Text(l10n.noChannelsFound),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16).copyWith(top: paddingTop + 16),
              itemCount: notifier.channels.length,
              itemBuilder: (context, index) {
                final channel = notifier.channels[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(channel.name),
                    subtitle: channel.description != null
                        ? Text(channel.description!)
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
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToChannelForm(context),
        child: const Icon(Icons.add),
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
}
