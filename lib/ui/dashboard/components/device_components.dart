import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:smarthome_byme/core/app_colors.dart';

class DeviceComponents extends StatefulWidget {
  final String nameDevice;
  final String idDevice;
  final String typeDevice;
  final int ping;
  final bool toggle;
  final String pathDevice;

  const DeviceComponents(
      {Key? key,
      required this.pathDevice,
      required this.nameDevice,
      required this.typeDevice,
      required this.ping,
      required this.toggle,
      required this.idDevice})
      : super(key: key);

  @override
  State<DeviceComponents> createState() => _DeviceComponentsState();
}

class _DeviceComponentsState extends State<DeviceComponents> {
  @override
  int a = 1;
  bool checkOnline = false;
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   if (checkOnline == widget.status) {
    //     print("offline");
    //   } else {
    //     print("online");
    //     checkOnline = widget.status;
    //     checkOnline = true;
    //     setState(() {});
    //   }
    //   // setState(() {
    //   // });
    // });
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
// Future.delayed(const Duration(milliseconds: 500), () {
//   setState(() {
//   });
// });
            if (checkOnline == true) ...[
              const Text(
                "Online",
                style: TextStyle(fontSize: 10, color: Colors.green),
              ),
            ],
            if (checkOnline == false) ...[
              const Text(
                "Ofiline",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
            ],

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
