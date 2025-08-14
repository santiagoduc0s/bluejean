import 'package:flutter/foundation.dart';
import 'package:lune/domain/entities/listener_entity.dart';
import 'package:lune/domain/entities/listener_notification_entity.dart';
import 'package:lune/domain/repositories/listener_notification_repository.dart';

class ListenerDetailNotifier extends ChangeNotifier {
  ListenerDetailNotifier({
    required this.listenerNotificationRepository,
    required this.listener,
  }) {
    _loadNotifications();
  }

  final ListenerNotificationRepository listenerNotificationRepository;
  final ListenerEntity listener;

  List<ListenerNotificationEntity> _notifications = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMorePages = true;

  List<ListenerNotificationEntity> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasMorePages => _hasMorePages;

  Future<void> _loadNotifications({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _hasError = false;
    _errorMessage = '';

    if (!loadMore) {
      _currentPage = 1;
      _notifications.clear();
    }

    notifyListeners();

    try {
      final notifications = await listenerNotificationRepository
          .getNotificationsByListenerId(listener.id, page: _currentPage);

      if (loadMore) {
        _notifications.addAll(notifications);
      } else {
        _notifications = notifications;
      }

      _hasMorePages = notifications.length == 20;
      _currentPage++;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadNotifications();
  }

  Future<void> loadMore() async {
    if (_hasMorePages && !_isLoading) {
      await _loadNotifications(loadMore: true);
    }
  }
}
