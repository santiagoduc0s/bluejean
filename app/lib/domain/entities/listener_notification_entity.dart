import 'package:equatable/equatable.dart';

class ListenerNotificationEntity extends Equatable {
  const ListenerNotificationEntity({
    required this.id,
    required this.listenerId,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final int id;
  final int listenerId;
  final String type;
  final String title;
  final String body;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        listenerId,
        type,
        title,
        body,
        createdAt,
      ];
}
