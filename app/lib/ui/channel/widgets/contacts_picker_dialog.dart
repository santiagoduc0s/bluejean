import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:lune/l10n/l10n.dart';

class ContactsPickerDialog extends StatefulWidget {
  const ContactsPickerDialog({required this.contacts, super.key});

  final List<Contact> contacts;

  @override
  State<ContactsPickerDialog> createState() => _ContactsPickerDialogState();
}

class _ContactsPickerDialogState extends State<ContactsPickerDialog> {
  List<Contact> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredContacts = widget.contacts;
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts =
          widget.contacts
              .where(
                (contact) =>
                    contact.displayName.toLowerCase().contains(query) ||
                    contact.phones.any((phone) => phone.number.contains(query)),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.importFromContacts,
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.search,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Contacts list
            Expanded(
              child:
                  _filteredContacts.isEmpty
                      ? Center(
                        child: Text(
                          widget.contacts.isEmpty
                              ? 'No contacts found'
                              : 'No contacts match your search',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = _filteredContacts[index];
                          final phoneNumber =
                              contact.phones.isNotEmpty
                                  ? contact.phones.first.number
                                  : '';

                          return ListTile(
                            title: Text(contact.displayName),
                            subtitle:
                                phoneNumber.isNotEmpty
                                    ? Text(phoneNumber)
                                    : null,
                            leading: const Icon(Icons.person),
                            onTap: () => Navigator.of(context).pop(contact),
                            dense: true,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
