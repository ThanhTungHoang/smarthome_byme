import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';

class TabDeviceComponents extends StatefulWidget {
  final String typeDevice;
  final List<String> listWifi;
  const TabDeviceComponents(
      {Key? key, required this.typeDevice, required this.listWifi})
      : super(key: key);

  @override
  State<TabDeviceComponents> createState() => _TabDeviceComponentsState();
}

class _TabDeviceComponentsState extends State<TabDeviceComponents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      color: Colors.white,
      child: Row(
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
              widget.typeDevice,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(RouteNames.setupWifiDevice,
                    queryParams: {
                      "nameDevice": widget.typeDevice,
                      "wifiSelect": widget.listWifi.toString()
                    });
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
              widget.typeDevice,
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
              widget.typeDevice,
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
    );
  }
}
