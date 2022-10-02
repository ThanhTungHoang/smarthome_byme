import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_byme/models/device/device_model.dart';
import 'package:smarthome_byme/views/dashboard/components/device_components.dart';

class TabDeviceViewInRoom extends StatefulWidget {
  final String listRoom;
  final String pathRoom;
  const TabDeviceViewInRoom(
      {Key? key, required this.listRoom, required this.pathRoom})
      : super(key: key);

  @override
  State<TabDeviceViewInRoom> createState() => _TabDeviceViewInRoomState();
}

class _TabDeviceViewInRoomState extends State<TabDeviceViewInRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.secondary,
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref(widget.pathRoom)
            .onValue
            .asBroadcastStream(),
        builder: (context, snapshot) {
          List<Device> deviceList = [];
          if (snapshot.hasData) {
            log("1");
            try {
              final values = (snapshot.data as DatabaseEvent).snapshot.value
                  as Map<dynamic, dynamic>;
              log("2");
              print(values.keys);
              values.forEach(
                (key, values) {
                  log("3");
                  print(values);
                  Device device = Device.fromJson(
                    jsonDecode(
                      jsonEncode(values),
                    ),
                  );

                  if (device.room == widget.listRoom) {
                    deviceList.add(
                      Device.fromJson(
                        jsonDecode(
                          jsonEncode(values),
                        ),
                      ),
                    );
                  }
                },
              );
            } catch (e) {
              return const Center(
                child: Text("No devices connected to the room yet! "),
              );
            }
            if (deviceList.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const Text("No device installed!"),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Click here to add a device."),
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              itemCount: deviceList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (widget.listRoom == deviceList[index].room) {
                  return DeviceComponents(
                    idDevice: deviceList[index].idDevice,
                    nameDevice: deviceList[index].nameDevice,
                    pathDevice: '',
                    ping: deviceList[index].ping,
                    toggle: deviceList[index].toggle,
                    typeDevice: deviceList[index].typeDevice,
                  );
                } else {
                  return const Center(
                    child: Text("No devices connected to the room yet!"),
                  );
                }
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
