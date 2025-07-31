import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/repositories/remote_storage_repository.dart';

class RemoteStorageRepositoryImpl implements RemoteStorageRepository {
  RemoteStorageRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<String> uploadFile({
    required Uint8List data,
    required String path,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${_apiClient.baseUrl}/api/v1/files/upload'),
    );

    request.headers.addAll(await _apiClient.getHeaders());
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        data,
        filename: 'upload_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );

    request.fields['path'] = path;
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.isSuccess) {
      final responseData = response.jsonBody;
      return responseData['url'] as String;
    } else {
      throw Exception('Failed to upload file: ${response.body}');
    }
  }
}
