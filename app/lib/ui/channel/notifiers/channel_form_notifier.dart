import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';

class ChannelFormNotifier extends ChangeNotifier {
  ChannelFormNotifier({
    required ChannelRepository channelRepository,
    required ListenerRepository listenerRepository,
    required PermissionService permissionService,
    ChannelEntity? channel,
  })  : _channelRepository = channelRepository,
        _listenerRepository = listenerRepository,
        _permissionService = permissionService,
        _channel = channel,
        _isEditMode = channel != null;

  final ChannelRepository _channelRepository;
  final ListenerRepository _listenerRepository;
  final PermissionService _permissionService;
  final ChannelEntity? _channel;
  final bool _isEditMode;

  bool _isLoading = false;
  bool _isLoadingListeners = false;
  String? _error;
  List<ListenerEntity> _listeners = [];
  ListenerEntity? _editingListener;

  bool get isEditMode => _isEditMode;
  bool get isLoading => _isLoading;
  bool get isLoadingListeners => _isLoadingListeners;
  String? get error => _error;
  ChannelEntity? get channel => _channel;
  List<ListenerEntity> get listeners => _listeners;
  ListenerEntity? get editingListener => _editingListener;

  Future<bool> saveChannel({
    required String name,
    String? description,
    String? status,
  }) async {
    if (name.trim().isEmpty) {
      _error = 'Name is required';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_isEditMode && _channel != null) {
        await _channelRepository.updateChannel(
          id: _channel.id,
          name: name,
          description: description,
          status: status,
        );
      } else {
        await _channelRepository.createChannel(
          name: name,
          description: description,
          status: status,
        );
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> loadListeners() async {
    if (_channel == null) return;

    _isLoadingListeners = true;
    notifyListeners();

    try {
      _listeners = await _listenerRepository.getListenersByChannel(_channel.id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingListeners = false;
      notifyListeners();
    }
  }

  Future<bool> addListenerItem(
    String name,
    String phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int thresholdMeters,
    String status,
  ) async {
    if (_channel == null) return false;

    try {
      final listener = await _listenerRepository.createListener(
        channelId: _channel.id,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        latitude: latitude,
        longitude: longitude,
        thresholdMeters: thresholdMeters,
        status: status,
      );
      _listeners.add(listener);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateListener(
    ListenerEntity listener,
    String name,
    String phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int thresholdMeters,
    String status,
  ) async {
    try {
      final updatedListener = await _listenerRepository.updateListener(
        id: listener.id,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        latitude: latitude,
        longitude: longitude,
        thresholdMeters: thresholdMeters,
        status: status,
      );

      final index = _listeners.indexWhere((l) => l.id == listener.id);
      if (index != -1) {
        _listeners[index] = updatedListener;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteListener(ListenerEntity listener) async {
    try {
      await _listenerRepository.deleteListener(listener.id);
      _listeners.removeWhere((l) => l.id == listener.id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void setEditingListener(ListenerEntity? listener) {
    _editingListener = listener;
    notifyListeners();
  }

  Future<List<Contact>> getContacts() async {
    final status = await _permissionService.status(PermissionType.contacts);
    if (status != PermissionStatus.granted) {
      final result = await _permissionService.request(PermissionType.contacts);
      if (result != PermissionStatus.granted) {
        throw Exception('Contacts permission denied');
      }
    }

    try {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
      return contacts
          .where(
            (contact) =>
                contact.phones.isNotEmpty && contact.displayName.isNotEmpty,
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load contacts: $e');
    }
  }

  Future<bool> importContactAsListener(Contact contact) async {
    if (_channel == null) return false;
    if (contact.phones.isEmpty) return false;

    try {
      final listener = await _listenerRepository.createListener(
        channelId: _channel.id,
        name: contact.displayName,
        phoneNumber: contact.phones.first.number,
        thresholdMeters: 200,
        status: 'active',
      );
      _listeners.add(listener);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> importMultipleContactsAsListeners(List<Contact> contacts) async {
    if (_channel == null) return false;

    const allSucceeded = true;
    final newListeners = <ListenerEntity>[];

    try {
      for (final contact in contacts) {
        if (contact.phones.isEmpty) continue;

        final listener = await _listenerRepository.createListener(
          channelId: _channel.id,
          name: contact.displayName,
          phoneNumber: contact.phones.first.number,
          thresholdMeters: 200,
          status: 'active',
        );
        newListeners.add(listener);
      }

      _listeners.addAll(newListeners);
      notifyListeners();
      return allSucceeded;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
