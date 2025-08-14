import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/repositories/repositories.dart';

class SupportRespositoryImpl extends SupportRepository {
  SupportRespositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<void> createTicket({
    required String email,
    required String title,
    required String description,
    required List<String> images,
  }) async {
    final response = await _apiClient.post(
      '/api/v1/support-tickets',
      body: {
        'email': email,
        'title': title,
        'description': description,
        'files': images,
      },
    );

    if (response.isError) {
      throw Exception('Failed to create support ticket');
    }
  }
}
