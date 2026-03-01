import 'dart:async';

import 'package:lune/l10n/gen_l10n/app_localizations.dart';

typedef MessageResolver = String Function(AppLocalizations l10n);

sealed class UiEffect {}

class ShowErrorSnackbar extends UiEffect {
  ShowErrorSnackbar(this.message);
  final MessageResolver message;
}

class ShowPrimarySnackbar extends UiEffect {
  ShowPrimarySnackbar(this.message);
  final MessageResolver message;
}

class RequestConfirmation extends UiEffect {
  RequestConfirmation({
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.completer,
  });

  final MessageResolver message;
  final MessageResolver confirmText;
  final MessageResolver cancelText;
  final Completer<bool> completer;
}
