import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/channel/notifiers/notifiers.dart';
import 'package:lune/ui/channel/widgets/contacts_picker_dialog.dart';
import 'package:lune/ui/channel/widgets/listener_form_widget.dart';
import 'package:lune/ui/channel/widgets/listener_list_widget.dart';
import 'package:lune/ui/listener_detail/listener_detail_screen.dart';
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

  bool _showListenerForm = false;
  String _selectedStatus = 'active';
  Contact? _prefilledContact;

  @override
  void initState() {
    super.initState();
    final notifier = context.read<ChannelFormNotifier>();
    if (notifier.isEditMode && notifier.channel != null) {
      _nameController.text = notifier.channel!.name;
      _descriptionController.text = notifier.channel!.description ?? '';
      _selectedStatus = notifier.channel!.status;
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
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
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: l10n.status,
                              border: const OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'active',
                                child: Text(l10n.active),
                              ),
                              DropdownMenuItem(
                                value: 'inactive',
                                child: Text(l10n.inactive),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Consumer<ChannelFormNotifier>(
                    builder: (context, notifier, child) {
                      if (!notifier.isEditMode) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          if (_showListenerForm) ...[
                            ListenerFormWidget(
                              listener: notifier.editingListener,
                              prefilledContact: _prefilledContact,
                              onSave:
                                  (
                                    name,
                                    phoneNumber,
                                    address,
                                    latitude,
                                    longitude,
                                    thresholdMeters,
                                    status,
                                  ) => _saveListener(
                                    context,
                                    notifier,
                                    name,
                                    phoneNumber,
                                    address,
                                    latitude,
                                    longitude,
                                    thresholdMeters,
                                    status,
                                  ),
                              onCancel: () => _cancelListenerForm(notifier),
                            ),
                            const SizedBox(height: 16),
                          ],
                          ListenerListWidget(
                            listeners: notifier.listeners,
                            onAdd: () => _showAddListenerForm(notifier),
                            onEdit:
                                (listener) =>
                                    _showEditListenerForm(notifier, listener),
                            onDelete:
                                (listener) =>
                                    _deleteListener(notifier, listener),
                            onImportFromContacts:
                                () => _importFromContacts(notifier),
                            onTap:
                                (listener) => _navigateToListenerDetail(
                                  context,
                                  listener,
                                ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
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
                      return FilledButton(
                        onPressed:
                            notifier.isLoading
                                ? null
                                : () => _saveChannel(context, notifier),
                        child:
                            notifier.isLoading
                                ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
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
      status: _selectedStatus,
    );

    if (success && context.mounted) {
      context.pop(true); // Return true to indicate success
    }
  }

  void _showAddListenerForm(ChannelFormNotifier notifier) {
    notifier.setEditingListener(null);
    setState(() {
      _showListenerForm = true;
    });
  }

  void _showEditListenerForm(
    ChannelFormNotifier notifier,
    ListenerEntity listener,
  ) {
    notifier.setEditingListener(listener);
    setState(() {
      _showListenerForm = true;
    });
  }

  void _cancelListenerForm(ChannelFormNotifier notifier) {
    notifier.setEditingListener(null);
    setState(() {
      _showListenerForm = false;
      _prefilledContact = null;
    });
  }

  Future<void> _saveListener(
    BuildContext context,
    ChannelFormNotifier notifier,
    String name,
    String phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int thresholdMeters,
    String status,
  ) async {
    bool success;
    if (notifier.editingListener != null) {
      success = await notifier.updateListener(
        notifier.editingListener!,
        name,
        phoneNumber,
        address,
        latitude,
        longitude,
        thresholdMeters,
        status,
      );
    } else {
      success = await notifier.addListenerItem(
        name,
        phoneNumber,
        address,
        latitude,
        longitude,
        thresholdMeters,
        status,
      );
    }

    if (success) {
      _cancelListenerForm(notifier);
    }
  }

  Future<void> _deleteListener(
    ChannelFormNotifier notifier,
    ListenerEntity listener,
  ) async {
    await notifier.deleteListener(listener);
  }

  Future<void> _importFromContacts(ChannelFormNotifier notifier) async {
    try {
      // Get contacts
      final contacts = await notifier.getContacts();

      if (contacts.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No contacts with phone numbers found'),
            ),
          );
        }
        return;
      }

      if (!mounted) return;

      final selectedContact = await showDialog<Contact>(
        context: context,
        builder: (context) => ContactsPickerDialog(contacts: contacts),
      );

      if (selectedContact != null) {
        notifier.setEditingListener(null);
        setState(() {
          _showListenerForm = true;
          _prefilledContact = selectedContact;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _navigateToListenerDetail(
    BuildContext context,
    ListenerEntity listener,
  ) {
    context.pushNamed(ListenerDetailScreen.path, extra: listener);
  }
}
