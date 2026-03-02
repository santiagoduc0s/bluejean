import 'package:lune/domain/repositories/repositories.dart';

class MessagingRepositoryFake implements MessagingRepository {
  @override
  Future<String?> getFCMToken() async => 'fake-fcm-token';
}
