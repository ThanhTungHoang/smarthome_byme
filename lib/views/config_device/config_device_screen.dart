import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/models/device/device_model.dart';
import 'package:smarthome_byme/views/config_device/components/card_device.dart';

class ConfigDeviceScreen extends StatefulWidget {
  final String pathEmailRequest;
  const ConfigDeviceScreen({
    super.key,
    required this.pathEmailRequest,
  });

  @override
  State<ConfigDeviceScreen> createState() => _ConfigDeviceScreenState();
}

class _ConfigDeviceScreenState extends State<ConfigDeviceScreen> {
  List<String> listRoom = [];
  List<Device> listDevice = [];
  late String pathDevice;
  late String pathRoom;
  @override
  Widget build(BuildContext context) {
    pathDevice = "admin/${widget.pathEmailRequest}/Device/";
    pathRoom = "admin/${widget.pathEmailRequest}/Room/";
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        GoRouter.of(context).goNamed(RouteNames.dashBoard);
                      },
                      icon: const Icon(
                        Icons.arrow_back_sharp,
                        size: 25,
                        color: Color(0xff464646),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Config Device',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(RouteNames.scanDevice,
                          queryParams: {
                            "pathEmailRequest": widget.pathEmailRequest
                          });
                    },
                    child: const Text(
                      "Start scan device by wifi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.black,
                  height: 0.1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "List device connected",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseDatabase.instance
                          .ref(pathDevice)
                          .onValue
                          .asBroadcastStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          listDevice.clear();
                          try {
                            final deviceData = (snapshot.data!).snapshot.value
                                as Map<dynamic, dynamic>;
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
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: listDevice.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CardDevice(
                                idDevice: listDevice[index].idDevice,
                                nameDevice: listDevice[index].nameDevice,
                                pathEmailRequest: widget.pathEmailRequest,
                                roomDevice: listDevice[index].room,
                                typeDevice: listDevice[index].typeDevice,
                                listDevice: listDevice,
                                listRoom: listRoom,
                              );
                            },
                          );
                        }
                        if (listDevice.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                const Text("No device installed!"),
                                TextButton(
                                  onPressed: () {},
                                  child:
                                      const Text("Click here to add a device."),
                                ),
                              ],
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
