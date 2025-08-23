import 'package:flutter/material.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class HomeNotifier extends ChangeNotifier {
  HomeNotifier({
    required ChannelRepository channelRepository,
    required DriverPositionRepository driverPositionRepository,
  }) : _channelRepository = channelRepository,
       _driverPositionRepository = driverPositionRepository;

  final ChannelRepository _channelRepository;
  final DriverPositionRepository _driverPositionRepository;

  List<ChannelEntity> _channels = [];
  List<ChannelEntity> _activeChannels = [];
  List<ChannelEntity> _inactiveChannels = [];
  bool _isLoading = false;
  String? _error;

  List<ChannelEntity> get channels => _channels;
  List<ChannelEntity> get activeChannels => _activeChannels;
  List<ChannelEntity> get inactiveChannels => _inactiveChannels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Location tracking getters
  bool get isLocationTracking => _driverPositionRepository.isLocationTracking;

  Future<void> loadChannels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load all channels concurrently
      final results = await Future.wait([
        _channelRepository.getChannels(),
        _channelRepository.getActiveChannels(),
        _channelRepository.getInactiveChannels(),
      ]);

      _channels = results[0];
      _activeChannels = results[1];
      _inactiveChannels = results[2];
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

      // Add to appropriate status list
      if (newChannel.status == 'active') {
        _activeChannels.add(newChannel);
      } else {
        _inactiveChannels.add(newChannel);
      }

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

      // Update in main list
      final index = _channels.indexWhere((channel) => channel.id == id);
      if (index != -1) {
        _channels[index] = updatedChannel;
      }

      // Remove from both status lists and add to appropriate one
      _activeChannels.removeWhere((channel) => channel.id == id);
      _inactiveChannels.removeWhere((channel) => channel.id == id);

      if (updatedChannel.status == 'active') {
        _activeChannels.add(updatedChannel);
      } else {
        _inactiveChannels.add(updatedChannel);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteChannel(int id) async {
    try {
      await _channelRepository.deleteChannel(id);
      _channels.removeWhere((channel) => channel.id == id);
      _activeChannels.removeWhere((channel) => channel.id == id);
      _inactiveChannels.removeWhere((channel) => channel.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Location tracking methods
  Future<void> toggleLocationTracking({
    String? notificationTitle,
    String? notificationText,
  }) async {
    try {
      if (isLocationTracking) {
        await _driverPositionRepository.stopLocationTracking();
      } else {
        await _driverPositionRepository.startLocationTracking(
          notificationTitle: notificationTitle,
          notificationText: notificationText,
        );
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
