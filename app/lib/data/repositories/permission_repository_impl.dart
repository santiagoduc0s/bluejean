import 'package:lune/data/services/services.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  PermissionRepositoryImpl({
    required PermissionService service,
  }) : _service = service;

  final PermissionService _service;

  @override
  Future<PermissionStatus> check(PermissionType permission) {
    return _service.status(permission);
  }

  @override
  Future<bool> openSettings() {
    return _service.openSettings();
  }

  @override
  Future<PermissionStatus> request(PermissionType permission) {
    return _service.request(permission);
  }
}
