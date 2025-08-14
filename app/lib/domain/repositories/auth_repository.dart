import 'dart:async';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/entities/entities.dart';

abstract class AuthRepository {
  Future<bool> isAuthenticated();

  Future<UserEntity?> currentUser();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInWithApple();

  Future<void> signInWithGoogle();

  Future<void> forgotPassword({String? email, String? phone});

  Future<void> updatePassword({required String password});

  Future<void> signOut();

  void clearSession();

  String? get accessToken;

  Future<void> deleteUser();

  Future<UserEntity> updateCurrentUser({
    String? name,
    String? email,
    NullableParameter<String?>? photo,
  });
}
