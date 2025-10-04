import 'package:flutter/material.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';
import 'package:lune/core/utils/utils.dart';

class DialogHelper {
  static Future<bool> confirm({
    required String message,
    required String confirmText,
    required String cancelText,
    String? title,
  }) {
    return AppProvider.get<CustomDialog>().confirm(
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      title: title,
    );
  }

  static Future<void> info({
    required String message,
    required String confirmText,
  }) {
    return AppProvider.get<CustomDialog>().info(
      message: message,
      confirmText: confirmText,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    return AppProvider.get<CustomDialog>().show<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }

  static Future<T?> showWithoutContext<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    return AppProvider.get<CustomDialog>().showWithoutContext<T>(
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }
}
