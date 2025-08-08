import 'package:flutter/material.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/ui.dart';
import 'package:provider/provider.dart';

class ListenerListWidget extends StatelessWidget {
  const ListenerListWidget({
    required this.listeners,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    super.key,
  });

  final List<ListenerEntity> listeners;
  final void Function(ListenerEntity listener) onEdit;
  final void Function(ListenerEntity listener) onDelete;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.listeners,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(l10n.addListener),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (listeners.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.noListenersAdded,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listeners.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final listener = listeners[index];
              return ListTile(
                title: Text(listener.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(listener.phoneNumber),
                    if (listener.address != null &&
                        listener.address!.isNotEmpty)
                      Text(
                        listener.address!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => onEdit(listener),
                      tooltip: l10n.edit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteDialog(context, listener),
                      tooltip: l10n.delete,
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, ListenerEntity listener) {
    final l10n = context.l10n;

    final notifier = context.read<ChannelFormNotifier>();

    showDialog<void>(
      context: context,
      builder: (context) => Provider.value(
        value: notifier,
        child: AlertDialog(
          title: Text(l10n.deleteListener),
          content: Text(l10n.deleteListenerConfirmation(listener.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(listener);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.delete),
            ),
          ],
        ),
      ),
    );
  }
}
