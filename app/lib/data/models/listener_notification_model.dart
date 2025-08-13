import 'package:lune/domain/entities/listener_notification_entity.dart';

class ListenerNotificationModel extends ListenerNotificationEntity {
  const ListenerNotificationModel({
    required super.id,
    required super.listenerId,
    required super.type,
    required super.title,
    required super.body,
    required super.createdAt,
  });

  factory ListenerNotificationModel.fromJson(Map<String, dynamic> json) {
    return ListenerNotificationModel(
      id: json['id'] as int,
      listenerId: json['listener_id'] as int,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listener_id': listenerId,
      'type': type,
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ListenerNotificationEntity toEntity() {
    return ListenerNotificationEntity(
      id: id,
      listenerId: listenerId,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
    );
  }
}
