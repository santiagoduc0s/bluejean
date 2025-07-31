import 'package:flutter/widgets.dart';

abstract class CustomRouter {
  RouterConfig<Object> get router;

  Future<T?> pushNamed<T>(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  });

  void goNamed(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  });

  void pop<T extends Object?>([T? result]);
}
