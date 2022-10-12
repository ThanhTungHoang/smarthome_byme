import 'dart:convert';
import 'dart:developer';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/generated/l10n.dart';
import 'package:smarthome_byme/models/device/device_model.dart';
import 'package:smarthome_byme/views/dashboard/components_main/device_components_tab_add_device.dart';
import 'package:smarthome_byme/views/dashboard/components_main/tab_device_view_in_room.dart';

class BodyMain extends StatefulWidget {
  final String pathEmailRequest;
  final String typeUser;
  const BodyMain(
      {super.key, required this.pathEmailRequest, required this.typeUser});

  @override
  State<BodyMain> createState() => _BodyMainState();
}

class _BodyMainState extends State<BodyMain> {
  List<String> listRoom = [];
  List<Device> listDevice = [];
  late String pathDevice;
  late String pathRoom;
  @override
  Widget build(BuildContext context) {
    pathDevice = "admin/${widget.pathEmailRequest}/Device/";
    pathRoom = "admin/${widget.pathEmailRequest}/Room/";
    return SizedBox(
      width: double.infinity,
      height: 500,
      child: StreamBuilder<DatabaseEvent>(
        stream:
            FirebaseDatabase.instance.ref(pathRoom).onValue.asBroadcastStream(),
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
                  onChange: (p0) {
                    setState(() {});
                  },
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
                    Text(
                      S.of(context).all_device,
                      style: const TextStyle(
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

                          final deviceData = (snapshot.data!).snapshot.value
                              as Map<dynamic, dynamic>;
                          log(deviceData.toString());
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
                            listDevice.clear();
                          }
                        }
                        if (listDevice.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                Text(
                                  S.of(context).number_device_installed,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                TextButton(
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                      RouteNames.configDevice,
                                      queryParams: {
                                        "pathEmailRequest":
                                            widget.pathEmailRequest,
                                      },
                                    );
                                  },
                                  child: Text(
                                    S.of(context).click_add_device,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
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
                            return DeviceComponentsTabAllDevice(
                              idDevice: listDevice[index].idDevice,
                              nameDevice: listDevice[index].nameDevice,
                              pathDevice: pathDevice,
                              ping: listDevice[index].ping,
                              toggle: listDevice[index].toggle,
                              typeDevice: listDevice[index].typeDevice,
                            );
                          },
                        );
                      },
                    ),
                    for (int i = 0; i < listRoom.length; i++) ...[
                      TabDeviceViewInRoom(
                          pathDevice: pathDevice, listRoom: listRoom[i]),
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
                        child: Text(S.of(context).config_device),
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                            RouteNames.configDevice,
                            queryParams: {
                              "pathEmailRequest": widget.pathEmailRequest,
                              "typeUser": widget.typeUser,
                            },
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: Text(S.of(context).config_room),
                        onTap: () {
                          GoRouter.of(context).goNamed(
                            RouteNames.configRoom,
                            queryParams: {
                              "pathEmailRequest": widget.pathEmailRequest,
                              "typeUser": widget.typeUser,
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
    );
  }
}
