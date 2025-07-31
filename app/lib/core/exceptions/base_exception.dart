abstract class BaseException implements Exception {
  BaseException([this.message]);

  final String? message;

  @override
  String toString() {
    if (message != null) {
      return '$runtimeType: $message';
    }
    return '$runtimeType';
  }
}
