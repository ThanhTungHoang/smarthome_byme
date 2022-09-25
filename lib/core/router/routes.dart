import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/views/config_device/config_device_screen.dart';
import 'package:smarthome_byme/views/config_device/scan_device_screen.dart';
import 'package:smarthome_byme/views/config_room/config_room_screen.dart';
import 'package:smarthome_byme/views/dashboard/dashboard_screen.dart';
import 'package:smarthome_byme/views/show_messenger/show_messenger_screen.dart';
import 'package:smarthome_byme/views/sign_in/sign_in_screen.dart';
import 'package:smarthome_byme/views/sign_up/sign_up_screen.dart';

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
      GoRoute(
        name: RouteNames.messenger,
        path: RoutePaths.messenger,
        builder: (BuildContext context, GoRouterState state) =>
            ShowMessengerScreen(
          pathEmailRequest: state.queryParams['pathEmailRequest'].toString(),
        ),
      ),
      GoRoute(
        name: RouteNames.configRoom,
        path: RoutePaths.configRoom,
        builder: (BuildContext context, GoRouterState state) =>
            ConfigRoomScreen(
          pathEmailRequest: state.queryParams['pathEmailRequest'].toString(),
        ),
      ),
      GoRoute(
        name: RouteNames.configDevice,
        path: RoutePaths.configDevice,
        builder: (BuildContext context, GoRouterState state) =>
            ConfigDeviceScreen(
          pathEmailRequest: state.queryParams['pathEmailRequest'].toString(),
        ),
      ),
      GoRoute(
        name: RouteNames.scanDevice,
        path: RoutePaths.scanDevice,
        builder: (BuildContext context, GoRouterState state) =>
            ScanDeviceScreen(
          pathEmailRequest: state.queryParams['pathEmailRequest'].toString(),
        ),
      ),
    ],
  );
}
