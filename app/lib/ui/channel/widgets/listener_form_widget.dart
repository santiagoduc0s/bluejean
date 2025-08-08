import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/map/location_picker_screen.dart';

class ListenerFormWidget extends StatefulWidget {
  const ListenerFormWidget({
    required this.onSave,
    required this.onCancel,
    super.key,
    this.listener,
  });

  final ListenerEntity? listener;

  final void Function(
    String name,
    String phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
  ) onSave;

  final VoidCallback onCancel;

  @override
  State<ListenerFormWidget> createState() => _ListenerFormWidgetState();
}

class _ListenerFormWidgetState extends State<ListenerFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.listener != null) {
      _nameController.text = widget.listener!.name;
      _phoneController.text = widget.listener!.phoneNumber;
      _addressController.text = widget.listener!.address ?? '';
      _latitude = widget.listener!.latitude;
      _longitude = widget.listener!.longitude;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text,
        _phoneController.text,
        _addressController.text.isEmpty ? null : _addressController.text,
        _latitude,
        _longitude,
      );
    }
  }

  Future<void> _openMapPicker() async {
    final result = await context.pushNamed<Map<String, dynamic>>(
      LocationPickerScreen.path,
      extra: {
        'latitude': _latitude,
        'longitude': _longitude,
      },
    );

    if (result != null) {
      setState(() {
        _latitude = result['latitude'] as double?;
        _longitude = result['longitude'] as double?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.listener == null ? l10n.addListener : l10n.editListener,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.nameIsRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.phoneNumberIsRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: l10n.address,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _openMapPicker,
                      icon: const Icon(Icons.location_on),
                      label: Text(l10n.setOnMap),
                    ),
                  ),
                  if (_latitude != null && _longitude != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _latitude = null;
                          _longitude = null;
                        });
                      },
                      icon: const Icon(Icons.clear),
                      tooltip: l10n.clear,
                    ),
                  ],
                ],
              ),
              if (_latitude != null && _longitude != null) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Lat: ${_latitude!.toStringAsFixed(6)}, '
                    'Lng: ${_longitude!.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _handleSave,
                    child: Text(l10n.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
