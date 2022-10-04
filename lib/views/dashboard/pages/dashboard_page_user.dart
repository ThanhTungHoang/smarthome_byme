import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/BLoC/auth_bloc/auth_bloc.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/views/dashboard/components_user/top_user.dart';

class DashBoardPageUser extends StatefulWidget {
  final String pathEmailRequest;
  final String nameUser;
  final String typeUser;
  const DashBoardPageUser(
      {Key? key,
      required this.pathEmailRequest,
      required this.nameUser,
      required this.typeUser})
      : super(key: key);

  @override
  State<DashBoardPageUser> createState() => _DashBoardPageUserState();
}

class _DashBoardPageUserState extends State<DashBoardPageUser> {
  late String pathDevice;
  late String pathRoom;
  late String pathInfor;
  late String pathUrlPhoto;
  @override
  Widget build(BuildContext context) {
    pathDevice = "admin/${widget.pathEmailRequest}/Device/";
    pathRoom = "admin/${widget.pathEmailRequest}/Room/";
    pathInfor = "admin/${widget.pathEmailRequest}/Infor/";
    pathUrlPhoto = "admin/${widget.pathEmailRequest}/Infor/UrlPhoto";
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopUser(
            pathEmailRequest: widget.pathEmailRequest,
            nameUser: widget.nameUser,
            typeUser: widget.typeUser,
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit,
                    size: 25,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Chỉnh sửa thông tin người dùng",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 5),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_upward_outlined,
                      color: Colors.green),
                  label: const Text(
                    "Nâng cấp gói",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 5),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.language,
                    color: Colors.purple,
                  ),
                  label: const Text(
                    "Thay đổi ngôn ngữ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 5),
                TextButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                    GoRouter.of(context).goNamed(RouteNames.signIn);
                  },
                  icon: const Icon(Icons.logout_outlined),
                  label: const Text(
                    "Đăng xuất",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
