import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/models/device/device_model.dart';

class ConfigDeviceScreen extends StatefulWidget {
  final String pathEmailRequest;
  final List<Device> listDevice;
  final List<String> listRoom;

  const ConfigDeviceScreen(
      {super.key,
      required this.pathEmailRequest,
      required this.listDevice,
      required this.listRoom});

  @override
  State<ConfigDeviceScreen> createState() => _ConfigDeviceScreenState();
}

class _ConfigDeviceScreenState extends State<ConfigDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(RouteNames.dashBoard);
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
            ],
          ),
        ),
      ),
    );
  }
}
