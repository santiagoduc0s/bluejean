import 'dart:typed_data';

abstract class RemoteStorageRepository {
  Future<String> uploadFile({
    required Uint8List data,
    required String path,
  });
}
