import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/ui/dashboard/dashboard_screen.dart';
import 'package:smarthome_byme/ui/sign_in/sign_in_screen.dart';
import 'package:smarthome_byme/ui/sign_up/sign_up_screen.dart';

part 'route_config.dart';

class Routes {
  static GoRouter route = GoRouter(
    initialLocation: RoutePaths.signIn,
    urlPathStrategy: UrlPathStrategy.path,
    debugLogDiagnostics: true,
    redirect: (state) {
      return null;
    },
    navigatorBuilder: (BuildContext context, goRoute, widget) {
      return widget;
    },
    routes: <GoRoute>[
      GoRoute(
        name: RouteNames.signIn,
        path: RoutePaths.signIn,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),
      GoRoute(
        name: RouteNames.signUp,
        path: RoutePaths.signUp,
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpScreen(),
      ),
      GoRoute(
        name: RouteNames.dashBoard,
        path: RoutePaths.dashBoard,
        builder: (BuildContext context, GoRouterState state) =>
            const DashBoardScreen(),
      ),
    ],
  );
}
