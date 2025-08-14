import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:lune/core/config/config.dart';
import 'package:lune/core/exceptions/exceptions.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/models/user_model.dart';
import 'package:lune/data/services/services.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required LocalStorageService localStorageService,
    required ApiClient apiClient,
    StreamController<UserEntity>? userController,
  }) : _localStorageService = localStorageService,
       _apiClient = apiClient,
       _userController =
           userController ?? StreamController<UserEntity>.broadcast();

  final StreamController<UserEntity> _userController;
  final ApiClient _apiClient;
  final LocalStorageService _localStorageService;

  bool? _isAuthenticated;
  String? _accessToken;

  @override
  Future<bool> isAuthenticated() async {
    if (_isAuthenticated != null) return _isAuthenticated!;
    await _getAccessToken();
    return _isAuthenticated ?? false;
  }

  @override
  String? get accessToken => _accessToken;

  @override
  Future<UserEntity?> currentUser() async {
    if (!await isAuthenticated()) return null;

    try {
      final response = await _apiClient.get('/api/v1/auth/me');

      if (response.isSuccess) {
        final data = response.jsonBody['data'] as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _getAccessToken() async {
    _accessToken = await _localStorageService.getAccessToken();
    _isAuthenticated = _accessToken != null;
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/v1/auth/sign-in',
      body: {'email': email, 'password': password},
    );

    if (response.isSuccess) {
      final data = response.jsonBody;
      final token = data['token'] as String;

      saveSession(accessToken: token);
    } else {
      final errorData = response.jsonBody;
      final errors = errorData['errors'] as Map<String, dynamic>?;

      final emailErrors =
          (errors?['email'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [];

      for (final error in emailErrors) {
        if (error.contains('taken')) {
          throw EmailAlreadyInUseException();
        } else if (error.contains('invalid')) {
          throw InvalidEmailException();
        } else if (error.contains('not verified')) {
          throw EmailNotVerifiedException();
        } else if (error.contains('credentials')) {
          throw InvalidCredentialException();
        }
      }

      throw Exception('Unexpected error during sign up');
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/v1/auth/sign-up',
      body: {'email': email, 'password': password},
    );

    if (response.isSuccess) {
      return;
    } else {
      final errorData = response.jsonBody;
      final errors = errorData['errors'] as Map<String, dynamic>?;

      final emailErrors =
          (errors?['email'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [];

      for (final error in emailErrors) {
        if (error.contains('taken')) {
          throw EmailAlreadyInUseException();
        } else if (error.contains('invalid')) {
          throw InvalidEmailException();
        }
      }

      throw Exception('Unexpected error during sign up');
    }
  }

  @override
  Future<void> signOut() async {
    await _apiClient.post('/api/v1/auth/sign-out');

    clearSession();
  }

  @override
  void clearSession() {
    _isAuthenticated = false;
    _accessToken = null;
    _localStorageService.setAccessToken(null);
  }

  void saveSession({required String accessToken}) {
    _accessToken = accessToken;
    _isAuthenticated = true;
    _localStorageService.setAccessToken(accessToken);
  }

  @override
  Future<void> deleteUser() async {
    final response = await _apiClient.delete('/api/v1/auth/me');

    if (response.isSuccess) {
      clearSession();
    } else {
      throw Exception('Failed to delete user account');
    }
  }

  @override
  Future<void> signInWithApple() async {
    final isAvailable = await SignInWithApple.isAvailable();

    if (!isAvailable) {
      throw Exception('Apple Sign-In is not available on this device');
    }

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );

      final identityToken = credential.identityToken;

      if (identityToken == null) {
        throw Exception('Failed to get Apple identity token');
      }

      final response = await _apiClient.post(
        '/api/v1/auth/sign-in-with-provider',
        body: {'provider': 'apple', 'id_token': identityToken},
      );

      if (response.isSuccess) {
        final data = response.jsonBody;
        final token = data['token'] as String;

        saveSession(accessToken: token);
        return;
      }

      throw Exception('Apple Sign-In failed: ${response.jsonBody}');
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw CancellOperationException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final instance = GoogleSignIn.instance;

      await instance.initialize(
        serverClientId:
            Env.serverClientId.isNotEmpty ? Env.serverClientId : null,
      );

      final googleUser = await instance.authenticate();

      final auth = googleUser.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      final response = await _apiClient.post(
        '/api/v1/auth/sign-in-with-provider',
        body: {'provider': 'google', 'id_token': idToken},
      );

      if (response.isSuccess) {
        final data = response.jsonBody;
        final token = data['token'] as String;

        saveSession(accessToken: token);
        return;
      }

      throw Exception('Google Sign-In failed: ${response.jsonBody}');
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw CancellOperationException();
      }
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({String? email, String? phone}) async {
    if (email == null && phone == null) {
      throw Exception('Either email or phone must be provided');
    }

    final response = await _apiClient.post(
      '/api/v1/auth/forgot-password',
      body: {
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      },
    );

    if (!response.isSuccess) {
      throw Exception('Failed to send password reset request');
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    throw UnimplementedError('Update password not implemented in API');
  }

  @override
  Future<UserEntity> updateCurrentUser({
    String? name,
    String? email,
    NullableParameter<String?>? photo,
  }) async {
    final response = await _apiClient.put(
      '/api/v1/auth/me',
      body: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (photo != null) 'photo': photo.value,
      },
    );

    if (response.isSuccess) {
      final data = response.jsonBody['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data);
      _userController.add(user);
      return user;
    } else {
      throw Exception('Failed to update user');
    }
  }
}
