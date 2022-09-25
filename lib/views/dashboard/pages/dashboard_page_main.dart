import 'dart:async';
import 'dart:convert';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/models/device/device_model.dart';
import '../../../core/router/routes.dart';
import '../components/device_components.dart';
import '../components/dialog_setting_device.dart';
import '../components/tab_device_view_in_room.dart';

class DashBoardPageMain extends StatefulWidget {
  final String pathEmailRequest;
  final String nameUser;
  final String content;
  final bool checkUnMessenger;
  const DashBoardPageMain(
      {Key? key,
      required this.pathEmailRequest,
      required this.nameUser,
      required this.content,
      required this.checkUnMessenger})
      : super(key: key);

  @override
  State<DashBoardPageMain> createState() => _DashBoardPageMainState();
}

class _DashBoardPageMainState extends State<DashBoardPageMain>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<String> listRoom = [];
  List<Device> listDevice = [];
  late Timer _timer;
  late String value;
  late String pathDevice;
  late String pathRoom;
  final storage = const FlutterSecureStorage();
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
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/background.png'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.content,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff464646),
                        ),
                      ),
                      Text(
                        widget.nameUser,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff464646),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  GoRouter.of(context).goNamed(
                    RouteNames.messenger,
                    queryParams: {"pathEmailRequest": widget.pathEmailRequest},
                  );
                },
                icon: widget.checkUnMessenger
                    ? const Icon(
                        Icons.mark_email_unread_outlined,
                        color: Colors.blue,
                        size: 30,
                      )
                    : const Icon(
                        Icons.email_outlined,
                        color: Colors.blue,
                        size: 30,
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 500,
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance
                .ref(pathRoom)
                .onValue
                .asBroadcastStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                listRoom.clear();
                try {
                  final dataRoom =
                      (snapshot.data!).snapshot.value as Map<dynamic, dynamic>;

                  dataRoom.forEach(
                    (key, values) {
                      listRoom.add(key);
                    },
                  );
                } catch (e) {
                  listRoom.clear();
                }
                return Stack(
                  children: [
                    ContainedTabBarView(
                      tabBarProperties: const TabBarProperties(
                        unselectedLabelColor: Color(0xffBDBDBD),
                        labelColor: Color(0xff464646),
                        position: TabBarPosition.top,
                        alignment: TabBarAlignment.start,
                        isScrollable: true,
                        indicatorWeight: 3,
                        indicatorColor: Color(0xff464646),
                        padding: EdgeInsets.only(bottom: 20, right: 50),
                        labelPadding: EdgeInsets.only(right: 20),
                        indicatorPadding: EdgeInsets.only(right: 20),
                      ),
                      tabs: [
                        const Text(
                          "Tất cả thiết bị",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        for (int i = 0; i < listRoom.length; i++) ...[
                          Text(
                            listRoom[i],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ]
                      ],
                      views: [
                        StreamBuilder<DatabaseEvent>(
                          stream: FirebaseDatabase.instance
                              .ref(pathDevice)
                              .onValue
                              .asBroadcastStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              listDevice.clear();
                              try {
                                final deviceData = (snapshot.data!)
                                    .snapshot
                                    .value as Map<dynamic, dynamic>;
                                try {
                                  deviceData.forEach(
                                    (key, values) {
                                      listDevice.add(
                                        Device.fromJson(
                                          jsonDecode(
                                            jsonEncode(values),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } catch (e) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        const Text("No device installed!"),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                              "Click here to add a device."),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } catch (e) {
                                return Center(
                                  child: Column(
                                    children: [
                                      const Text("No device installed!"),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                            "Click here to add a device."),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            if (listDevice.isEmpty) {
                              return Center(
                                child: Column(
                                  children: [
                                    const Text("No device installed!"),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                          "Click here to add a device."),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return GridView.builder(
                              itemCount: listDevice.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                childAspectRatio: 1.2,
                                mainAxisSpacing: 15,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onPanCancel: () => _timer.cancel(),
                                  onPanDown: (_) => {
                                    _timer = Timer(
                                      const Duration(seconds: 2),
                                      () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => DialogSettingDevice(
                                            path: pathDevice,
                                            id: listDevice[index].idDevice,
                                            name: listDevice[index].nameDevice,
                                            room: listDevice[index]
                                                .room
                                                .toString(),
                                          ),
                                        );
                                      },
                                    )
                                  },
                                  child: DeviceComponents(
                                    idDevice: listDevice[index].idDevice,
                                    nameDevice: listDevice[index].nameDevice,
                                    pathDevice: pathDevice,
                                    ping: listDevice[index].ping,
                                    toggle: listDevice[index].toggle,
                                    typeDevice: listDevice[index].typeDevice,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        for (int i = 0; i < listRoom.length; i++) ...[
                          TabDeviceViewInRoom(
                              pathRoom: pathRoom, listRoom: listRoom[i]),
                        ],
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Color(0xff464646),
                        ),
                        iconSize: 30,
                        // elevation: 50,
                        enabled: true,
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            child: const Text("Thêm phòng"),
                            onTap: () {
                              GoRouter.of(context).goNamed(
                                RouteNames.configRoom,
                                queryParams: {
                                  "pathEmailRequest": widget.pathEmailRequest,
                                },
                              );
                            },
                          ),
                          PopupMenuItem(
                            child: const Text("Thêm thiết bị"),
                            onTap: () {
                              GoRouter.of(context).pushNamed(
                                RouteNames.configDevice,
                                queryParams: {
                                  "pathEmailRequest": widget.pathEmailRequest,
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            DatabaseReference ref = FirebaseDatabase.instance.ref(pathDevice);

            await ref.update(
              {
                "123Device": {
                  "typeDevice": "Switch",
                  "nameDevice": "Cong tac",
                  "ping": 3,
                  "toggle": true,
                  "idDevice": "123Device",
                  "lock": "",
                  "temp": "",
                  "humi": "",
                  "co2": "",
                  "red": "",
                  "green": "",
                  "blue": "",
                  "voltage": "",
                  "ampe": "",
                  "wat": "",
                  "room": "",
                }
              },
            );
          },
          child: const Text("fake device"),
        ),
      ],
    );
  }
}
