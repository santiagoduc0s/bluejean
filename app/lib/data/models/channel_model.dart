import 'package:lune/domain/entities/entities.dart';

class ChannelModel extends ChannelEntity {
  const ChannelModel({
    required super.id,
    required super.name,
    required super.description,
    required super.status,
    required super.updatedAt,
    required super.createdAt,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
