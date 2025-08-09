import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/map/location_picker_screen.dart';

class PlaceSuggestion {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlaceSuggestion({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      placeId: (json['place_id'] as String?) ?? '',
      description: json['description'] as String? ?? '',
      mainText: json['structured_formatting']?['main_text'] as String? ?? '',
      secondaryText:
          json['structured_formatting']?['secondary_text'] as String? ?? '',
    );
  }
}

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
  final _searchController = SearchController();

  double? _latitude;
  double? _longitude;
  bool _isLoadingSuggestions = false;
  List<PlaceSuggestion> _suggestions = [];
  Timer? _debounceTimer;

  static const String _googleApiKey = "AIzaSyDI8pTScjcDsjr-NHzp1E7yRLglz_OxmCE";

  @override
  void initState() {
    super.initState();
    if (widget.listener != null) {
      _nameController.text = widget.listener!.name;
      _phoneController.text = widget.listener!.phoneNumber;
      _addressController.text = widget.listener!.address ?? '';
      _searchController.text = widget.listener!.address ?? '';
      _latitude = widget.listener!.latitude;
      _longitude = widget.listener!.longitude;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
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
        _searchController.text.isEmpty ? null : _searchController.text,
        _latitude,
        _longitude,
      );
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.length < 3) {
      setState(() {
        _suggestions = [];
        _isLoadingSuggestions = false;
      });
      return;
    }

    setState(() {
      _isLoadingSuggestions = true;
    });

    try {
      final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeQueryComponent(query)}'
          '&key=$_googleApiKey'
          '&components=country:us|country:mx|country:es'
          '&types=address';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List<dynamic>;

        setState(() {
          _suggestions = predictions
              .map((json) =>
                  PlaceSuggestion.fromJson(json as Map<String, dynamic>))
              .toList();
          _isLoadingSuggestions = false;
        });
      }
    } catch (e) {
      setState(() {
        _suggestions = [];
        _isLoadingSuggestions = false;
      });
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&key=$_googleApiKey'
          '&fields=geometry';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']['geometry']['location'];

        setState(() {
          _latitude = location['lat'] as double?;
          _longitude = location['lng'] as double?;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(query);
    });
  }

  void _onSuggestionSelected(PlaceSuggestion suggestion) {
    setState(() {
      _searchController.text = suggestion.description;
      _addressController.text = suggestion.description;
      _suggestions = [];
    });
    // Remove focus from the SearchBar to hide keyboard after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).unfocus();
    });
    _getPlaceDetails(suggestion.placeId);
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
    final colors = Theme.of(context).colorScheme;

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
              // Address search using Flutter's SearchBar
              SearchBar(
                controller: _searchController,
                hintText: l10n.typeAddressForLocation,
                leading: const Icon(Icons.search),
                trailing: [
                  if (_isLoadingSuggestions)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (_latitude != null && _longitude != null)
                    Icon(Icons.location_on, color: colors.primary),
                ],
                onChanged: _onSearchChanged,
                onSubmitted: (query) {
                  if (_suggestions.isNotEmpty) {
                    _onSuggestionSelected(_suggestions.first);
                  }
                },
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: colors.outline),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(colors.surface),
                elevation: WidgetStateProperty.all(0),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                overlayColor: WidgetStateProperty.all(
                    colors.surfaceContainerHighest.withValues(alpha: 0.1)),
                constraints: const BoxConstraints(minHeight: 56),
              ),
              // Suggestions list
              if (_suggestions.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.outline),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: colors.outline.withValues(alpha: 0.2),
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return InkWell(
                        onTap: () => _onSuggestionSelected(suggestion),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: colors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      suggestion.mainText,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: colors.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (suggestion
                                        .secondaryText.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        suggestion.secondaryText,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              // Helper text
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 16),
                child: Text(
                  (_latitude != null && _longitude != null)
                      ? l10n.locationFound
                      : l10n.typeAddressForLocation,
                  style: TextStyle(
                    fontSize: 12,
                    color: (_latitude != null && _longitude != null)
                        ? colors.primary
                        : colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
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
