import 'package:flutter/foundation.dart';
import 'package:lune/domain/entities/entities.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier();

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;
  bool get isNotAuthenticated => _currentUser == null;

  void initialize(UserEntity? user) {
    if (user == null) return;

    _currentUser = user;
    notifyListeners();
  }

  void setUser(UserEntity user) {
    _currentUser = user;
    notifyListeners();
  }

  void signOut() {
    if (_currentUser == null) return;
    _currentUser = null;
    notifyListeners();
  }
}
