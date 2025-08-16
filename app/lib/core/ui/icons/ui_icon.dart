import 'package:flutter/material.dart';

/// Abstract class for UIIcon.
// ignore: one_member_abstracts
abstract class UIIcon {
  /// Logo icon.
  Widget logo({double? size});

  Widget downloadAndroid({double? width});

  Widget downloadIOS({double? width});
}
