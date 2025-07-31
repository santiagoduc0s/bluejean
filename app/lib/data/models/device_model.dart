import 'package:lune/domain/entities/entities.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.id,
    required super.identifier,
    required super.model,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as int,
      identifier: json['identifier'] as String,
      model: json['model'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
