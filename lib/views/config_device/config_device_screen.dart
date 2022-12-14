import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/models/device/device_model.dart';
import 'package:smarthome_byme/views/config_device/components/card_device.dart';

class ConfigDeviceScreen extends StatefulWidget {
  final String pathEmailRequest;
  final String typeUser;
  const ConfigDeviceScreen({
    super.key,
    required this.pathEmailRequest,
    required this.typeUser,
  });

  @override
  State<ConfigDeviceScreen> createState() => _ConfigDeviceScreenState();
}

class _ConfigDeviceScreenState extends State<ConfigDeviceScreen> {
  List<String> listRoom = [];
  List<Device> listDevice = [];
  late String pathDevice;
  late String pathRoom;
  bool maxCountDevice = false;
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (maxCountDevice == true) {
                          final snackBar = SnackBar(
                            content: const Text(
                              '???? ?????t gi???i h???n thi???t b???, vui l??ng n??ng c???p g??i d???ch v???!',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: Colors.teal[100],
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          GoRouter.of(context).pushNamed(RouteNames.scanDevice,
                              queryParams: {
                                "pathEmailRequest": widget.pathEmailRequest
                              });
                        }
                      },
                      icon: const Icon(
                        Icons.search_outlined,
                        size: 50,
                        color: Colors.blue,
                      ),
                      label: const Text(
                        "Scan device with wifi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref(pathDevice)
                      .onValue
                      .asBroadcastStream(),
                  builder: (context, snapshot) {
                    // print("olalalala");
                    try {
                      if (snapshot.hasData) {
                        final device = (snapshot.data!).snapshot.value
                            as Map<dynamic, dynamic>;
                        int countDevice = device.keys.length;
                        if (widget.typeUser == "Test User") {
                          if (countDevice >= 3) {
                            maxCountDevice = true;
                          } else {
                            maxCountDevice = false;
                          }
                        }
                        if (widget.typeUser == "Family") {
                          if (countDevice >= 10) {
                            maxCountDevice = true;
                          } else {
                            maxCountDevice = false;
                          }
                        }
                        if (widget.typeUser == "Enterprise") {
                          if (countDevice >= 100) {
                            maxCountDevice = true;
                          } else {
                            maxCountDevice = false;
                          }
                        }
                        if (widget.typeUser == "Unlimited") {
                          maxCountDevice = false;
                        }
                        return Text(
                          "T???ng s??? thi???t b???: $countDevice",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    } catch (e) {
                      // print("eeeeeeeeeeeeeee");
                      return const Text(
                        "T???ng s??? thi???t b???: 0",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
              
                    return const Text(
                      "T???ng s??? thi???t b???: Loading...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                if (widget.typeUser == "Test User") ...[
                  const Text(
                    "T???i ??a: 3",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (widget.typeUser == "Family") ...[
                  const Text(
                    "T???i ??a: 10",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (widget.typeUser == "Enterprise") ...[
                  const Text(
                    "T???i ??a: 100",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (widget.typeUser == "Unlimited") ...[
                  const Text(
                    "T???i ??a: Unlimited",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
                            listDevice.clear();
                          }
                          if (listDevice.isEmpty) {
                            return const Center(
                              child: Text(
                                "No device installed!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
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
