import 'dart:typed_data';

import 'package:lune/domain/repositories/repositories.dart';

class RemoteStorageRepositoryFake implements RemoteStorageRepository {
  @override
  Future<String> uploadFile({
    required Uint8List data,
    required String path,
  }) async =>
      'https://fake-storage.example.com/$path';
}
