import 'package:equatable/equatable.dart';
import 'package:lune/core/utils/utils.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    required this.updatedAt,
    required this.createdAt,
  });

  final int id;
  final String? name;
  final String email;
  final String? photo;
  final DateTime updatedAt;
  final DateTime createdAt;

  String get initials {
    if (name == null || name!.isEmpty) return '';
    final parts = name!.split(' ');
    if (parts.isEmpty) return '';
    final firstInitial = parts[0].isNotEmpty ? parts[0][0] : '';
    final lastInitial =
        parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return '$firstInitial$lastInitial'.toUpperCase();
  }

  @override
  String toString() {
    return 'UserAuth(\n'
        '  id: $id,\n'
        '  name: $name,\n'
        '  email: $email,\n'
        '  photo: $photo,\n'
        '  updatedAt: $updatedAt,\n'
        '  createdAt: $createdAt,\n'
        ')';
  }

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    NullableParameter<String?>? photo,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photo: photo != null ? photo.value : this.photo,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props {
    return [id, name, email, photo, updatedAt, createdAt];
  }
}
