import 'package:flutter/material.dart';
import 'package:smarthome_byme/views/dashboard/components_main/body_main.dart';
import 'package:smarthome_byme/views/dashboard/components_main/top_main.dart';

class DashBoardPageMain extends StatefulWidget {
  final String pathEmailRequest;
  final String nameUser;
  final String content;
  final bool checkUnMessenger;
  final String typeUser;
  const DashBoardPageMain({
    Key? key,
    required this.pathEmailRequest,
    required this.nameUser,
    required this.content,
    required this.checkUnMessenger,
    required this.typeUser,
  }) : super(key: key);

  @override
  State<DashBoardPageMain> createState() => _DashBoardPageMainState();
}

class _DashBoardPageMainState extends State<DashBoardPageMain>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late String pathDevice;
  late String pathRoom;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    pathDevice = "admin/${widget.pathEmailRequest}/Device/";
    pathRoom = "admin/${widget.pathEmailRequest}/Room/";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TopMain(
          pathEmailRequest: widget.pathEmailRequest,
          nameUser: widget.nameUser,
          content: widget.content,
          checkUnMessenger: widget.checkUnMessenger,
        ),
        const SizedBox(height: 30),
        BodyMain(
          pathEmailRequest: widget.pathEmailRequest,
          typeUser: widget.typeUser,
        ),
      ],
    );
  }
}
