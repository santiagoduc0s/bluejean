import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';

class PermissionRepositoryFake implements PermissionRepository {
  @override
  Future<PermissionStatus> check(PermissionType permission) async =>
      PermissionStatus.granted;

  @override
  Future<PermissionStatus> request(PermissionType permission) async =>
      PermissionStatus.granted;

  @override
  Future<bool> openSettings() async => true;
}
