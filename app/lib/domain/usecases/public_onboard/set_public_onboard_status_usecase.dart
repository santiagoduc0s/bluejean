import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';

class GetPublicOnboardStatusUseCase {
  GetPublicOnboardStatusUseCase(this._repository);

  final PublicOnboardRepository _repository;

  Future<PublicOnboardStatus> call() {
    return _repository.getStatus();
  }
}
