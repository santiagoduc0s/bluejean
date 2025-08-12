import 'package:lune/domain/entities/entities.dart';

class ListenerModel extends ListenerEntity {
  const ListenerModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.thresholdMeters,
    required super.status,
    required super.updatedAt,
    required super.createdAt,
    super.address,
    super.latitude,
    super.longitude,
  });

  factory ListenerModel.fromJson(Map<String, dynamic> json) {
    return ListenerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      address: json['address'] as String?,
      latitude: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : null,
      thresholdMeters: json['threshold_meters'] as int? ?? 200,
      status: json['status'] as String? ?? 'active',
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'threshold_meters': thresholdMeters,
      'status': status,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
