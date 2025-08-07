import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/channel/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class ChannelFormPage extends StatefulWidget {
  const ChannelFormPage({super.key});

  @override
  State<ChannelFormPage> createState() => _ChannelFormPageState();
}

class _ChannelFormPageState extends State<ChannelFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final notifier = context.read<ChannelFormNotifier>();
    if (notifier.isEditMode && notifier.channel != null) {
      _nameController.text = notifier.channel!.name;
      _descriptionController.text = notifier.channel!.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChannelFormNotifier>(
          builder: (context, notifier, child) {
            return Text(
              notifier.isEditMode ? l10n.editChannel : l10n.createChannel,
            );
          },
        ),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '${l10n.name} *',
                        hintText: l10n.enterChannelName,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.nameIsRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        hintText: l10n.enterChannelDescription,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Consumer<ChannelFormNotifier>(
                      builder: (context, notifier, child) {
                        if (notifier.error != null) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              notifier.error!,
                              style: TextStyle(color: colors.onErrorContainer),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Consumer<ChannelFormNotifier>(
                      builder: (context, notifier, child) {
                        return ElevatedButton(
                          onPressed: notifier.isLoading
                              ? null
                              : () => _saveChannel(context, notifier),
                          child: notifier.isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(
                                  notifier.isEditMode
                                      ? l10n.update
                                      : l10n.create,
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveChannel(
    BuildContext context,
    ChannelFormNotifier notifier,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    notifier.clearError();

    final success = await notifier.saveChannel(
      name: _nameController.text,
      description: _descriptionController.text,
    );

    if (success && context.mounted) {
      context.pop(true); // Return true to indicate success
    }
  }
}
