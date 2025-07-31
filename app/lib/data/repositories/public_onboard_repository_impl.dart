import 'package:lune/data/services/local_storage_service.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';

class PublicOnboardRepositoryImpl extends PublicOnboardRepository {
  PublicOnboardRepositoryImpl({
    required LocalStorageService service,
  }) : _service = service;

  final LocalStorageService _service;

  @override
  Future<PublicOnboardStatus> getStatus() {
    return _service.getStatus();
  }

  @override
  Future<void> setStatus(PublicOnboardStatus value) {
    return _service.setStatus(value);
  }
}
