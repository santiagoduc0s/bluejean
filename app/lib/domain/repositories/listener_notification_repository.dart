import 'package:lune/domain/entities/listener_notification_entity.dart';

abstract class ListenerNotificationRepository {
  Future<List<ListenerNotificationEntity>> getNotificationsByListenerId(
    int listenerId, {
    int page = 1,
    int perPage = 20,
  });
}
