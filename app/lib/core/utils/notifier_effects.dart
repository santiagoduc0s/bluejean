import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lune/core/utils/ui_effect.dart';

mixin NotifierEffects on ChangeNotifier {
  final _effectController = StreamController<UiEffect>.broadcast();

  Stream<UiEffect> get effects => _effectController.stream;

  @protected
  void emit(UiEffect effect) => _effectController.add(effect);

  @protected
  void emitErrorSnackbar(MessageResolver message) =>
      emit(ShowErrorSnackbar(message));

  @protected
  void emitPrimarySnackbar(MessageResolver message) =>
      emit(ShowPrimarySnackbar(message));

  @protected
  Future<bool> emitConfirmDialog({
    required MessageResolver message,
    required MessageResolver confirmText,
    required MessageResolver cancelText,
  }) {
    final completer = Completer<bool>();
    emit(
      RequestConfirmation(
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        completer: completer,
      ),
    );
    return completer.future;
  }

  @override
  void dispose() {
    _effectController.close();
    super.dispose();
  }
}
