import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/BLoC/dashboard_bloc/dashboard_bloc.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/views/dashboard/pages/dashboard_page_enegry.dart';
import 'package:smarthome_byme/views/dashboard/pages/dashboard_page_main.dart';
import 'package:smarthome_byme/views/dashboard/pages/dashboard_page_user.dart';

void main() {
  runApp(const DashBoardScreen());
}

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    context.read<DashboardBloc>().add(DashboardCkeckLogout());
    context.read<DashboardBloc>().add(DashboardRequest());
    super.initState();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardLogout) {
          GoRouter.of(context).goNamed(RouteNames.signIn);
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color(0xffF407DD),
            unselectedItemColor: Colors.blue,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage("assets/icons/navigation/ic_home.png"),
                    size: 24),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage("assets/icons/navigation/ic_enegry.png"),
                    size: 24),
                label: "Enegry",
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage("assets/icons/navigation/ic_user.png"),
                    size: 24),
                label: "User",
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (state is DashboardLoading) ...[
                        Center(
                          child: Column(
                            children: [
                              const CircularProgressIndicator(),
                              TextButton.icon(
                                  onPressed: () {
                                    context
                                        .read<DashboardBloc>()
                                        .add(DashboardRequest());
                                  },
                                  icon: const Icon(Icons.replay_outlined),
                                  label: const Text(
                                    "Tải lại trang...",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300),
                                  ))
                            ],
                          ),
                        ),
                      ],
                      if (state is DashboardLoaded) ...[
                        if (_selectedIndex == 0) ...[
                          DashBoardPageMain(
                            pathEmailRequest: state.pathEmail,
                            nameUser: state.nameUser,
                            content: state.content,
                            checkUnMessenger: state.unMessenger,
                            typeUser: state.typeUser,
                          ),
                        ],
                        if (_selectedIndex == 1) ...[
                          const HomePageEnegry(),
                        ],
                        if (_selectedIndex == 2) ...[
                          DashBoardPageUser(
                            pathEmailRequest: state.pathEmail,
                            nameUser: state.nameUser,
                            typeUser: state.typeUser,
                          ),
                        ]
                      ],
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
