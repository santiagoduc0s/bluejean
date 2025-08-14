import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {
  const DeviceEntity({
    required this.id,
    required this.identifier,
    required this.model,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String identifier;
  final String model;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceEntity copyWith({
    int? id,
    String? identifier,
    String? fcmToken,
    String? model,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeviceEntity(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      model: model ?? this.model,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props {
    return [id, identifier, model, createdAt, updatedAt];
  }
}
