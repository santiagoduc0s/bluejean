import 'package:lune/domain/enums/enums.dart';

abstract class PublicOnboardRepository {
  Future<PublicOnboardStatus> getStatus();

  Future<void> setStatus(PublicOnboardStatus status);
}
