import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lune/domain/repositories/repositories.dart';

class MessagingRepositoryImpl extends MessagingRepository {
  MessagingRepositoryImpl({this.firebaseMessaging});

  final FirebaseMessaging? firebaseMessaging;

  @override
  Future<String?> getFCMToken() async {
    try {
      final messaging = firebaseMessaging ?? FirebaseMessaging.instance;
      return await messaging.getToken();
    } catch (e) {
      return null;
    }
  }
}
