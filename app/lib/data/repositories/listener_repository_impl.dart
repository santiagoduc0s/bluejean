import 'package:lune/core/utils/api_client.dart';
import 'package:lune/data/models/models.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/listener_repository.dart';

class ListenerRepositoryImpl implements ListenerRepository {
  const ListenerRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<ListenerEntity>> getListenersByChannel(
    int channelId, {
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await apiClient.get(
      '/api/v1/channels/$channelId/listeners',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    final data = response.jsonBody['data'] as List<dynamic>;
    return data
        .map((json) => ListenerModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ListenerEntity> createListener({
    required int channelId,
    required String name,
    required String phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int? thresholdMeters,
    String? status,
  }) async {
    final body = {
      'channel_id': channelId,
      'name': name,
      'phone_number': phoneNumber,
    };

    if (address != null) body['address'] = address;
    if (latitude != null) body['latitude'] = latitude;
    if (longitude != null) body['longitude'] = longitude;
    if (thresholdMeters != null) body['threshold_meters'] = thresholdMeters;
    if (status != null) body['status'] = status;

    final response = await apiClient.post(
      '/api/v1/listeners',
      body: body,
    );

    return ListenerModel.fromJson(
      response.jsonBody['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<ListenerEntity> updateListener({
    required int id,
    String? name,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int? thresholdMeters,
    String? status,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (address != null) data['address'] = address;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (thresholdMeters != null) data['threshold_meters'] = thresholdMeters;
    if (status != null) data['status'] = status;

    final response = await apiClient.put(
      '/api/v1/listeners/$id',
      body: data,
    );

    return ListenerModel.fromJson(
      response.jsonBody['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> deleteListener(int id) async {
    await apiClient.delete('/api/v1/listeners/$id');
  }
}
