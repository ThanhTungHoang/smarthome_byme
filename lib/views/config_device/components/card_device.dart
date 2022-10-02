import 'package:flutter/material.dart';
import 'package:smarthome_byme/models/device/device_model.dart';
import 'package:smarthome_byme/views/config_device/components/dialog_delete_device.dart';
import 'package:smarthome_byme/views/config_device/components/dialog_rename_device.dart';
import 'package:smarthome_byme/views/config_device/components/dialog_selection_room.dart';

class CardDevice extends StatefulWidget {
  final String pathEmailRequest;
  final List<Device> listDevice;
  final List<String> listRoom;
  final String idDevice;
  final String nameDevice;
  final String typeDevice;
  final String? roomDevice;
  const CardDevice(
      {super.key,
      required this.pathEmailRequest,
      required this.idDevice,
      required this.nameDevice,
      required this.typeDevice,
      this.roomDevice,
      required this.listDevice,
      required this.listRoom});

  @override
  State<CardDevice> createState() => _CardDeviceState();
}

class _CardDeviceState extends State<CardDevice> {
  late String pathDevice;
  late String pathRoom;
  @override
  Widget build(BuildContext context) {
    pathDevice = "admin/${widget.pathEmailRequest}/Device/";
    pathRoom = "admin/${widget.pathEmailRequest}/Room/";
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Name: ",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.nameDevice,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Id: ",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.idDevice,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Type: ",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.typeDevice,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (widget.roomDevice == "") ...[
                      const Text.rich(
                        TextSpan(
                          text: "Room: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                          children: <InlineSpan>[
                            TextSpan(
                              text: "Not added yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ] else ...[
                      Text.rich(
                        TextSpan(
                          text: "Room: ",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                          children: <InlineSpan>[
                            TextSpan(
                              text: widget.roomDevice,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const Spacer(flex: 1),
              ],
            ),
            Row(
              children: [
                const Spacer(flex: 2),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (_) => DialogReNameDevice(
                        idDevice: widget.idDevice,
                        listDevice: widget.listDevice,
                        pathDevice: pathDevice,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
                const Spacer(flex: 1),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DialogSelectionRoom(
                        pathDevice: pathDevice,
                        idDevice: widget.idDevice,
                        pathRoom: pathRoom,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_home_rounded),
                ),
                const Spacer(flex: 1),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DialogDeleteDevice(
                        pathDevice: pathDevice,
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
