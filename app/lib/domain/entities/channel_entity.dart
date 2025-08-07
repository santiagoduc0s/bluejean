import 'package:equatable/equatable.dart';

class ChannelEntity extends Equatable {
  const ChannelEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.updatedAt,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String? description;
  final DateTime updatedAt;
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChannelEntity(\n'
        '  id: $id,\n'
        '  name: $name,\n'
        '  description: $description,\n'
        '  updatedAt: $updatedAt,\n'
        '  createdAt: $createdAt,\n'
        ')';
  }

  ChannelEntity copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return ChannelEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
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
      updatedAt,
      createdAt,
    ];
  }
}
