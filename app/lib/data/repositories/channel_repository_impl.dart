import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/models/models.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class ChannelRepositoryImpl implements ChannelRepository {
  ChannelRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ChannelEntity>> getChannels() async {
    final response = await _apiClient.get('/api/v1/channels');

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as List<dynamic>;
      return data
          .map((json) => ChannelModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get channels');
    }
  }

  @override
  Future<List<ChannelEntity>> getActiveChannels() async {
    final response = await _apiClient.get('/api/v1/channels?status=active');

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as List<dynamic>;
      return data
          .map((json) => ChannelModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get active channels');
    }
  }

  @override
  Future<List<ChannelEntity>> getInactiveChannels() async {
    final response = await _apiClient.get('/api/v1/channels?status=inactive');

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as List<dynamic>;
      return data
          .map((json) => ChannelModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to get inactive channels');
    }
  }

  @override
  Future<ChannelEntity> createChannel({
    required String name,
    String? description,
    String? status,
  }) async {
    final response = await _apiClient.post(
      '/api/v1/channels',
      body: {
        'name': name,
        'description': description,
        if (status != null) 'status': status,
      },
    );

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      return ChannelModel.fromJson(data);
    } else {
      throw Exception('Failed to create channel: ${response.body}');
    }
  }

  @override
  Future<ChannelEntity> updateChannel({
    required int id,
    String? name,
    String? description,
    String? status,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (status != null) body['status'] = status;

    final response = await _apiClient.put(
      '/api/v1/channels/$id',
      body: body,
    );

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      return ChannelModel.fromJson(data);
    } else {
      throw Exception('Failed to update channel: ${response.body}');
    }
  }

  @override
  Future<void> deleteChannel(int id) async {
    final response = await _apiClient.delete('/api/v1/channels/$id');

    if (!response.isSuccess) {
      throw Exception('Failed to delete channel: ${response.body}');
    }
  }

  @override
  Future<ChannelEntity> getChannel(int id) async {
    final response = await _apiClient.get('/api/v1/channels/$id');

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      return ChannelModel.fromJson(data);
    } else {
      throw Exception('Failed to get channel: ${response.body}');
    }
  }
}
