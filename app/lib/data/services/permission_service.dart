import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class PermissionService {
  static const Map<PermissionType, ph.Permission> _permissionMap = {
    PermissionType.camera: ph.Permission.camera,
    PermissionType.photos: ph.Permission.photos,
    PermissionType.location: ph.Permission.location,
    PermissionType.notifications: ph.Permission.notification,
    PermissionType.contacts: ph.Permission.contacts,
  };

  ph.Permission _toPermission(PermissionType perm) {
    final p = _permissionMap[perm];
    if (p == null) {
      throw ArgumentError('Unsupported permission: $perm');
    }
    return p;
  }

  PermissionStatus _mapStatus(ph.PermissionStatus status) {
    switch (status) {
      case ph.PermissionStatus.granted:
      case ph.PermissionStatus.provisional:
        return PermissionStatus.granted;
      case ph.PermissionStatus.permanentlyDenied:
        return PermissionStatus.permanentlyDenied;
      case ph.PermissionStatus.denied:
      case ph.PermissionStatus.restricted:
      case ph.PermissionStatus.limited:
        return PermissionStatus.denied;
    }
  }

  Future<PermissionStatus> status(PermissionType permission) async {
    if ((kIsWeb || Platform.isAndroid) && permission == PermissionType.photos) {
      return PermissionStatus.granted;
    }

    final raw = await _toPermission(permission).status;
    return _mapStatus(raw);
  }

  Future<PermissionStatus> request(PermissionType permission) async {
    final raw = await _toPermission(permission).request();
    return _mapStatus(raw);
  }

  Future<bool> openSettings() {
    return ph.openAppSettings();
  }
}
