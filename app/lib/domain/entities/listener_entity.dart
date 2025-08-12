import 'package:equatable/equatable.dart';

class ListenerEntity extends Equatable {
  const ListenerEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.thresholdMeters,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    this.address,
    this.latitude,
    this.longitude,
  });

  final int id;
  final String name;
  final String phoneNumber;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int thresholdMeters;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;

  @override
  String toString() {
    return 'ListenerEntity(\n'
        '  id: $id,\n'
        '  name: $name,\n'
        '  phoneNumber: $phoneNumber,\n'
        '  address: $address,\n'
        '  latitude: $latitude,\n'
        '  longitude: $longitude,\n'
        '  thresholdMeters: $thresholdMeters,\n'
        '  status: $status,\n'
        '  updatedAt: $updatedAt,\n'
        '  createdAt: $createdAt,\n'
        ')';
  }

  ListenerEntity copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int? thresholdMeters,
    String? status,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return ListenerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      thresholdMeters: thresholdMeters ?? this.thresholdMeters,
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
      phoneNumber,
      address,
      latitude,
      longitude,
      thresholdMeters,
      status,
      updatedAt,
      createdAt,
    ];
  }
}
