import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome_byme/BLoC/scan_device_bloc/scan_device_bloc.dart';

class TabDeviceComponents extends StatefulWidget {
  final String typeDevice;
  final String nameDevice;
  const TabDeviceComponents({
    Key? key,
    required this.typeDevice,
    required this.nameDevice,
  }) : super(key: key);

  @override
  State<TabDeviceComponents> createState() => _TabDeviceComponentsState();
}

class _TabDeviceComponentsState extends State<TabDeviceComponents> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      // color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.typeDevice != "switch") ...[
                  const ImageIcon(
                    AssetImage("assets/icons/device/switch.png"),
                    size: 40,
                    color: Color(0xff01A4FF),
                  ),
                  const Spacer(),
                  Text(
                    widget.nameDevice,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ScanDeviceBloc>()
                          .add(ScanDeviceSetup(widget.nameDevice));
                    },
                    child: const Text("Kết nối"),
                  ),
                ],
                if (widget.typeDevice == "light") ...[
                  const ImageIcon(
                    AssetImage("assets/icons/device/light.png"),
                    size: 40,
                    color: Color(0xffCC01FF),
                  ),
                  const Spacer(),
                  Text(
                    widget.nameDevice,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Kết nối"),
                  ),
                ],
                if (widget.typeDevice == "temp") ...[
                  const ImageIcon(
                    AssetImage("assets/icons/device/temperature.png"),
                    size: 40,
                    color: Color(0xffFF0101),
                  ),
                  const Spacer(),
                  Text(
                    widget.nameDevice,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Kết nối"),
                  ),
                ],
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
