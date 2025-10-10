import 'package:flutter/material.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';

class AppDialog extends CustomDialog {
  AppDialog(this.context);

  final BuildContext Function() context;

  @override
  Future<bool> confirm({
    required String message,
    required String confirmText,
    required String cancelText,
    String? title,
  }) async {
    final result = await show<bool>(
      context: context(),
      builder:
          (_) => ConfirmDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
          ),
    );
    return result != null && result == true;
  }

  @override
  Future<void> info({required String message, required String confirmText}) {
    return show<void>(
      context: context(),
      builder: (_) => InfoDialog(message: message, confirmText: confirmText),
    );
  }

  @override
  Future<T?> show<T>({
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
    return showDialog<T>(
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

  @override
  Future<T?> showWithoutContext<T>({
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
    return show<T>(
      context: context(),
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
