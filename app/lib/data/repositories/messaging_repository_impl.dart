import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lune/domain/repositories/repositories.dart';

class MessagingRepositoryImpl extends MessagingRepository {
  MessagingRepositoryImpl({FirebaseMessaging? firebaseMessaging})
    : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _firebaseMessaging;

  @override
  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }
}
