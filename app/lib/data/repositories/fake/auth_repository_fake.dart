import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';

class AuthRepositoryFake implements AuthRepository {
  bool _isAuthenticated = false;
  UserEntity _user = UserEntity(
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
    photo: null,
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  @override
  Future<bool> isAuthenticated() async => _isAuthenticated;

  @override
  String? get accessToken => _isAuthenticated ? 'fake-token' : null;

  @override
  Future<UserEntity?> currentUser() async =>
      _isAuthenticated ? _user : null;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _isAuthenticated = true;
    _user = _user.copyWith(email: email);
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> forgotPassword({String? email, String? phone}) async {}

  @override
  Future<void> updatePassword({required String password}) async {}

  @override
  Future<void> signOut() async => clearSession();

  @override
  void clearSession() => _isAuthenticated = false;

  @override
  Future<void> deleteUser() async => clearSession();

  @override
  Future<UserEntity> updateCurrentUser({
    String? name,
    String? email,
    NullableParameter<String?>? photo,
  }) async =>
      _user = _user.copyWith(
        name: name,
        email: email,
        photo: photo,
        updatedAt: DateTime.now(),
      );
}
