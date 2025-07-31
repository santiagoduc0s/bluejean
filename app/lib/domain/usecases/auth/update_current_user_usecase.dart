import 'dart:typed_data';

import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class UpdateCurrentUserUsecase {
  UpdateCurrentUserUsecase({
    required AuthRepository authRepository,
    required RemoteStorageRepository remoteStorageRepository,
  })  : _authRepository = authRepository,
        _remoteStorageRepository = remoteStorageRepository;

  final AuthRepository _authRepository;
  final RemoteStorageRepository _remoteStorageRepository;

  Future<UserEntity> call({
    String? name,
    String? email,
    NullableParameter<Uint8List?>? photo,
  }) async {
    String? photoUrl;
    if (photo != null && photo.value != null) {
      photoUrl = await _remoteStorageRepository.uploadFile(
        data: photo.value!,
        path: '/profile',
      );
    }

    return _authRepository.updateCurrentUser(
      name: name,
      email: email,
      photo: NullableParameter(photoUrl),
    );
  }
}
