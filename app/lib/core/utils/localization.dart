import 'package:flutter/material.dart';
import 'package:lune/l10n/gen_l10n/app_localizations.dart';

class Localization {
  Localization(this.getRootContext);

  BuildContext Function() getRootContext;

  AppLocalizations get tr {
    return AppLocalizations.of(getRootContext());
  }
}
