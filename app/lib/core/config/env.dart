class Env {
  static const String environment = String.fromEnvironment('ENV');

  static const String baseUrl = String.fromEnvironment('BASE_URL');

  static const String serverClientId =
      String.fromEnvironment('SERVER_CLIENT_ID');

  static const String googleApiKey =
      String.fromEnvironment('GOOGLE_API_KEY');
}
