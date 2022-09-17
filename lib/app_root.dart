import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'BLoC/auth_bloc/auth_bloc.dart';
import 'BLoC/dashboard_bloc/dashboard_bloc.dart';
import 'BLoC/dashboard_main_bloc/dashboard_main_bloc.dart';
import 'core/app_colors.dart';
import 'core/router/routes.dart';
import 'resources/auth_repository.dart';
import 'resources/dashboard_repository.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => DashBoardRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => DashboardBloc(
              dashBoardRepository: context.read<DashBoardRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => DashboardMainBloc(
              dashBoardRepository: context.read<DashBoardRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.colorBackground,
            fontFamily: 'NotoSans',
          ),
          debugShowCheckedModeBanner: false,
          routeInformationProvider: Routes.route.routeInformationProvider,
          routeInformationParser: Routes.route.routeInformationParser,
          routerDelegate: Routes.route.routerDelegate,
          // title: 'GoRouter',
        ),
      ),
    );
  }
}
