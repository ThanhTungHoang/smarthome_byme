import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_byme/models/device/device_model.dart';
import 'package:smarthome_byme/ui/dashboard/components/device_components.dart';

class TabDeviceView extends StatefulWidget {
  final String nameRoom;
  final String path;
  const TabDeviceView({Key? key, required this.nameRoom, required this.path})
      : super(key: key);

  @override
  State<TabDeviceView> createState() => _TabDeviceViewState();
}

class _TabDeviceViewState extends State<TabDeviceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.secondary,
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref(widget.path)
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

                  if (device.room == widget.nameRoom) {
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
              return const Text("No device");
            }
            if (deviceList.isEmpty) {
              return const Text("No Device");
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
                if (widget.nameRoom == deviceList[index].room) {
                  return DeviceComponents(
                    idDevice: deviceList[index].idDevice,
                    nameDevice: deviceList[index].nameDevice,
                    pathDevice: '',
                    ping: deviceList[index].ping,
                    toggle: deviceList[index].toggle,
                    typeDevice: deviceList[index].typeDevice,
                  );
                } else {
                  return const Text("No Device");
                }
              },
            );
          }
          return const Text("Error?????");
        },
      ),
    );
  }
}
