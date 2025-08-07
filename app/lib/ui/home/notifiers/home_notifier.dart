import 'package:flutter/material.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class HomeNotifier extends ChangeNotifier {
  HomeNotifier({
    required ChannelRepository channelRepository,
  }) : _channelRepository = channelRepository;

  final ChannelRepository _channelRepository;

  List<ChannelEntity> _channels = [];
  bool _isLoading = false;
  String? _error;

  List<ChannelEntity> get channels => _channels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChannels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _channels = await _channelRepository.getChannels();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createChannel({
    required String name,
    String? description,
  }) async {
    try {
      final newChannel = await _channelRepository.createChannel(
        name: name,
        description: description,
      );
      _channels.add(newChannel);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateChannel({
    required int id,
    String? name,
    String? description,
  }) async {
    try {
      final updatedChannel = await _channelRepository.updateChannel(
        id: id,
        name: name,
        description: description,
      );
      final index = _channels.indexWhere((channel) => channel.id == id);
      if (index != -1) {
        _channels[index] = updatedChannel;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteChannel(int id) async {
    try {
      await _channelRepository.deleteChannel(id);
      _channels.removeWhere((channel) => channel.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
