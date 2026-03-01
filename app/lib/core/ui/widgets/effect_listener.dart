import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lune/core/ui/alerts/alerts.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:provider/provider.dart';

class EffectListener<T extends NotifierEffects> extends StatefulWidget {
  const EffectListener({required this.child, super.key});

  final Widget child;

  @override
  State<EffectListener<T>> createState() => _EffectListenerState<T>();
}

class _EffectListenerState<T extends NotifierEffects>
    extends State<EffectListener<T>> {
  StreamSubscription<UiEffect>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<T>().effects.listen(_handleEffect);
  }

  void _handleEffect(UiEffect effect) {
    if (!mounted) return;

    final l10n = context.l10n;
    final snackbar = getIt<CustomSnackbar>();
    final dialog = getIt<CustomDialog>();

    switch (effect) {
      case ShowErrorSnackbar(:final message):
        snackbar.show(ErrorSnackBar(text: message(l10n)));
      case ShowPrimarySnackbar(:final message):
        snackbar.show(PrimarySnackBar(text: message(l10n)));
      case RequestConfirmation(
        :final message,
        :final confirmText,
        :final cancelText,
        :final completer,
      ):
        dialog
            .confirm(
              message: message(l10n),
              confirmText: confirmText(l10n),
              cancelText: cancelText(l10n),
            )
            .then(completer.complete);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
