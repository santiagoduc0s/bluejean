import 'package:lune/domain/entities/entities.dart';

abstract class ChannelRepository {
  Future<List<ChannelEntity>> getChannels();
  Future<List<ChannelEntity>> getActiveChannels();
  Future<List<ChannelEntity>> getInactiveChannels();

  Future<ChannelEntity> createChannel({
    required String name,
    String? description,
    String? status,
  });

  Future<ChannelEntity> updateChannel({
    required int id,
    String? name,
    String? description,
    String? status,
  });

  Future<void> deleteChannel(int id);

  Future<ChannelEntity> getChannel(int id);
}
