import 'package:lune/domain/entities/entities.dart';

abstract class ChannelRepository {
  Future<List<ChannelEntity>> getChannels();

  Future<ChannelEntity> createChannel({
    required String name,
    String? description,
  });

  Future<ChannelEntity> updateChannel({
    required int id,
    String? name,
    String? description,
  });

  Future<void> deleteChannel(int id);

  Future<ChannelEntity> getChannel(int id);
}
