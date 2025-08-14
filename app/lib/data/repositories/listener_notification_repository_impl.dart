import 'package:lune/core/utils/api_client.dart';
import 'package:lune/data/models/listener_notification_model.dart';
import 'package:lune/domain/entities/listener_notification_entity.dart';
import 'package:lune/domain/repositories/listener_notification_repository.dart';

class ListenerNotificationRepositoryImpl
    implements ListenerNotificationRepository {
  const ListenerNotificationRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<ListenerNotificationEntity>> getNotificationsByListenerId(
    int listenerId, {
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await apiClient.get(
      '/api/v1/listeners/$listenerId/notifications',
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );

    final data = response.jsonBody['data'] as List<dynamic>;
    return data
        .map(
          (json) =>
              ListenerNotificationModel.fromJson(
                json as Map<String, dynamic>,
              ).toEntity(),
        )
        .toList();
  }
}
