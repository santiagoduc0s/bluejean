import 'package:lune/domain/entities/entities.dart';

abstract class ListenerRepository {
  Future<List<ListenerEntity>> getListenersByChannel(
    int channelId, {
    String? search,
  });

  Future<ListenerEntity> createListener({
    required int channelId,
    required String name,
    required String phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int? thresholdMeters,
    String? status,
  });

  Future<ListenerEntity> updateListener({
    required int id,
    String? name,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int? thresholdMeters,
    String? status,
  });

  Future<void> deleteListener(int id);
}
