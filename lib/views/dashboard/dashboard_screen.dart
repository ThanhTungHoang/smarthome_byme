import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome_byme/BLoC/dashboard_bloc/dashboard_bloc.dart';
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
    return BlocBuilder<DashboardBloc, DashboardState>(
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
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                      if (state is DashboardLoaded) ...[
                        if (_selectedIndex == 0) ...[
                          DashBoardPageMain(
                            pathEmailRequest: state.pathEmail,
                            nameUser: state.nameUser,
                            content: state.content,
                            checkUnMessenger: state.unMessenger,
                          ),
                        ],
                        if (_selectedIndex == 1) ...[
                          const HomePageEnegry(),
                        ],
                        if (_selectedIndex == 2) ...[
                          const DashBoardPageUser(),
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
