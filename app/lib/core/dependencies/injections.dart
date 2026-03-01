import 'package:lune/core/ui/alerts/alerts.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/router/router.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';
import 'package:lune/ui/preference/notifiers/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  /// CORE
  Provider.value(value: getIt<CustomDialog>()),
  Provider.value(value: getIt<Localization>()),

  /// GLOBAL NOTIFIERS
  ChangeNotifierProvider.value(value: getIt<AuthNotifier>()),
  ChangeNotifierProvider.value(value: getIt<PreferenceNotifier>()),

  /// ROUTER
  Provider.value(value: getIt<CustomRouter>()),
];
