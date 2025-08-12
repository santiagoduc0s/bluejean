import 'package:equatable/equatable.dart';

class ChannelEntity extends Equatable {
  const ChannelEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String? description;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChannelEntity(\n'
        '  id: $id,\n'
        '  name: $name,\n'
        '  description: $description,\n'
        '  status: $status,\n'
        '  updatedAt: $updatedAt,\n'
        '  createdAt: $createdAt,\n'
        ')';
  }

  ChannelEntity copyWith({
    int? id,
    String? name,
    String? description,
    String? status,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return ChannelEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      status,
      updatedAt,
      createdAt,
    ];
  }
}
