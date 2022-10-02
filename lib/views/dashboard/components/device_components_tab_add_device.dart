import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:smarthome_byme/core/app_colors.dart';
import 'package:smarthome_byme/views/dashboard/components/status_device.dart';

class DeviceComponentsTabAllDevice extends StatefulWidget {
  final String nameDevice;
  final String idDevice;
  final String typeDevice;
  final int ping;
  final bool toggle;
  final String pathDevice;

  const DeviceComponentsTabAllDevice(
      {Key? key,
      required this.pathDevice,
      required this.nameDevice,
      required this.typeDevice,
      required this.ping,
      required this.toggle,
      required this.idDevice})
      : super(key: key);

  @override
  State<DeviceComponentsTabAllDevice> createState() =>
      _DeviceComponentsTabAllDeviceState();
}

class _DeviceComponentsTabAllDeviceState
    extends State<DeviceComponentsTabAllDevice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 160,
      // height: 135,
      decoration: BoxDecoration(
        color: AppColors.backgrondDevice,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.typeDevice == "Switch") ...[
                  const ImageIcon(
                    AssetImage("assets/icons/device/switch.png"),
                    size: 40,
                    color: Color(0xff01A4FF),
                  ),
                  FlutterSwitch(
                    activeColor: const Color(0xff01A4FF),
                    width: 40,
                    height: 20,
                    toggleSize: 14,
                    borderRadius: 100,
                    value: widget.toggle,
                    onToggle: (val) async {
                      DatabaseReference ref = FirebaseDatabase.instance
                          .ref("${widget.pathDevice}/${widget.idDevice}");
                      await ref.update(
                        {
                          "toggle": !widget.toggle,
                        },
                      );
                    },
                  ),
                ],
                if (widget.typeDevice == "Light") ...[
                  const ImageIcon(
                    AssetImage("assets/icons/device/light.png"),
                    size: 40,
                    color: Color(0xffCC01FF),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          onPressed: () {},
                          icon:
                              Image.asset("assets/icons/device/ic_colors.png"),
                        ),
                      ),
                      FlutterSwitch(
                        activeColor: const Color(0xffCC01FF),
                        width: 40,
                        height: 20,
                        toggleSize: 14,
                        borderRadius: 100,
                        value: widget.toggle,
                        onToggle: (val) async {
                          DatabaseReference ref = FirebaseDatabase.instance
                              .ref("${widget.pathDevice}/${widget.idDevice}");
                          await ref.update(
                            {
                              "toggle": !widget.toggle,
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
                if (widget.typeDevice == "Temp") ...[
                  const ImageIcon(
                    AssetImage("assets/icons/device/temperature.png"),
                    size: 40,
                    color: Color(0xffFF0101),
                  ),
                  SizedBox(
                    width: 60,
                    height: 40,
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            ImageIcon(
                              AssetImage("assets/icons/device/ic_temp.png"),
                              size: 20,
                              color: Colors.orange,
                            ),
                            Text(
                              "43 °C",
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            ImageIcon(
                              AssetImage("assets/icons/device/ic_hum.png"),
                              size: 19,
                              color: Colors.blue,
                            ),
                            Text(
                              "98 %",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ],
            ),
            const SizedBox(height: 20),
            StatusDevice(
              ping: widget.ping,
            ),
            Text(
              widget.nameDevice,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xff464646),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
