import 'package:flutter/material.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class ChannelFormNotifier extends ChangeNotifier {
  ChannelFormNotifier({
    required ChannelRepository channelRepository,
    ChannelEntity? channel,
  })  : _channelRepository = channelRepository,
        _channel = channel,
        _isEditMode = channel != null;

  final ChannelRepository _channelRepository;
  final ChannelEntity? _channel;
  final bool _isEditMode;

  bool _isLoading = false;
  String? _error;

  bool get isEditMode => _isEditMode;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ChannelEntity? get channel => _channel;

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
}
