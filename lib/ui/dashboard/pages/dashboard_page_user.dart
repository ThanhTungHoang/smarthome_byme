import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/BLoC/auth_bloc/auth_bloc.dart';
import 'package:smarthome_byme/core/router/routes.dart';

class DashBoardPageUser extends StatefulWidget {
  const DashBoardPageUser({Key? key}) : super(key: key);

  @override
  State<DashBoardPageUser> createState() => _DashBoardPageUserState();
}

class _DashBoardPageUserState extends State<DashBoardPageUser> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Màn hình hiện Thông tin tài khoản"),
        TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
              GoRouter.of(context).goNamed(RouteNames.signIn);
            },
            child: const Text("Log out!..........."))
      ],
    );
  }
}
