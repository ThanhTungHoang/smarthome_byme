import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smarthome_byme/BLoC/change_language_cubit/change_language_cubit.dart';
import 'package:smarthome_byme/BLoC/scan_device_bloc/scan_device_bloc.dart';
import 'package:smarthome_byme/generated/l10n.dart';
import 'package:smarthome_byme/resources/scandevice_repository.dart';
import 'BLoC/auth_bloc/auth_bloc.dart';
import 'BLoC/dashboard_bloc/dashboard_bloc.dart';

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
          create: (context) => ChangeLanguageCubit(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => DashBoardRepository(),
        ),
        RepositoryProvider(
          create: (context) => ScanDeviceRepository(),
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
            create: (context) => ScanDeviceBloc(
                scanDeviceRepository: context.read<ScanDeviceRepository>()),
          ),
        ],
        child: BlocBuilder<ChangeLanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              theme: ThemeData(
                scaffoldBackgroundColor: AppColors.colorBackground,
                fontFamily: 'NotoSans',
              ),
              debugShowCheckedModeBanner: false,
              routeInformationProvider: Routes.route.routeInformationProvider,
              routeInformationParser: Routes.route.routeInformationParser,
              routerDelegate: Routes.route.routerDelegate,
              locale: locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', "US"),
                Locale('vi', "VN"),
              ],
              // title: 'GoRouter',
            );
          },
        ),
      ),
    );
  }
}
