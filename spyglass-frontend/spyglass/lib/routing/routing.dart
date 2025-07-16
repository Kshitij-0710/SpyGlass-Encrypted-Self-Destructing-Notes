// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:spyglass/routing/routing.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends $AppRouter {  // <- Change this line
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    CupertinoRoute(page: HomeRoute.page, initial: true),
    CupertinoRoute(page: CreateNoteRoute.page),
    CupertinoRoute(page: ViewNoteRoute.page),
  ];
}