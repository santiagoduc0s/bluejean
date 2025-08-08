import 'package:flutter/material.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class ChannelFormNotifier extends ChangeNotifier {
  ChannelFormNotifier({
    required ChannelRepository channelRepository,
    required ListenerRepository listenerRepository,
    ChannelEntity? channel,
  })  : _channelRepository = channelRepository,
        _listenerRepository = listenerRepository,
        _channel = channel,
        _isEditMode = channel != null;

  final ChannelRepository _channelRepository;
  final ListenerRepository _listenerRepository;
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
        );
      } else {
        await _channelRepository.createChannel(
          name: name,
          description: description,
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
  ) async {
    try {
      final updatedListener = await _listenerRepository.updateListener(
        id: listener.id,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        latitude: latitude,
        longitude: longitude,
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
}
