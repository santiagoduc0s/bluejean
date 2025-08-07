import 'package:lune/domain/entities/entities.dart';
import 'package:lune/ui/auth/notifiers/auth_notifier.dart';

class AppSession {
  AppSession._();

  static final AppSession _instance = AppSession._();
  static AppSession get instance => _instance;

  late AuthNotifier _authNotifier;

  // ignore: use_setters_to_change_properties
  void initialize(AuthNotifier authNotifier) {
    _authNotifier = authNotifier;
  }

  AuthNotifier get authNotifier {
    return _authNotifier;
  }

  UserEntity? get currentUser => _authNotifier.currentUser;

  bool get isAuthenticated => _authNotifier.isAuthenticated;
}
