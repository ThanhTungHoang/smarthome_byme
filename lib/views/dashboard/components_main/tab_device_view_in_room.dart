import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_byme/generated/l10n.dart';
import 'package:smarthome_byme/models/device/device_model.dart';
import 'package:smarthome_byme/views/dashboard/components_main/device_components.dart';

class TabDeviceViewInRoom extends StatefulWidget {
  final String listRoom;
  final String pathDevice;
  const TabDeviceViewInRoom(
      {Key? key, required this.listRoom, required this.pathDevice})
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
            .ref(widget.pathDevice)
            .onValue
            .asBroadcastStream(),
        builder: (context, snapshot) {
          List<Device> deviceList = [];
          if (snapshot.hasData) {
            try {
              final values = (snapshot.data as DatabaseEvent).snapshot.value
                  as Map<dynamic, dynamic>;
              values.forEach(
                (key, values) {
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
              deviceList.clear();
            }
            if (deviceList.isEmpty) {
              return Center(
                child: Text(
                  S.of(context).no_devices_connected_to_the_room_yet,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
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
                    pathDevice: widget.pathDevice,
                    ping: deviceList[index].ping,
                    toggle: deviceList[index].toggle,
                    typeDevice: deviceList[index].typeDevice,
                  );
                } else {
                  return Center(
                    child: Text(
                      S.of(context).no_devices_connected_to_the_room_yet,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
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
