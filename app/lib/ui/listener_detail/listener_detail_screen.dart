import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/domain/entities/listener_entity.dart';
import 'package:lune/ui/listener_detail/widgets/listener_detail_page.dart';

class ListenerDetailScreen {
  const ListenerDetailScreen();

  static const path = '/listener-detail';

  static GoRoute route({List<RouteBase> routes = const []}) => GoRoute(
    path: path,
    name: path,
    builder: (context, state) {
      final listener = state.extra! as ListenerEntity;

      return Scaffold(
        appBar: AppBar(title: Text(listener.name), centerTitle: true),
        body: ListenerDetailPage(listener: listener),
      );
    },
    routes: routes,
  );
}
