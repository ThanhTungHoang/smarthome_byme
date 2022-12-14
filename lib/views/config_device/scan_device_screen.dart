import 'dart:developer';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smarthome_byme/BLoC/scan_device_bloc/scan_device_bloc.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/views/config_device/components/tab_device_components.dart';

class ScanDeviceScreen extends StatefulWidget {
  final String pathEmailRequest;
  const ScanDeviceScreen({super.key, required this.pathEmailRequest});

  @override
  State<ScanDeviceScreen> createState() => _ScanDeviceScreenState();
}

class _ScanDeviceScreenState extends State<ScanDeviceScreen> {
  final TextEditingController _passWifi = TextEditingController();

  String? selectedValueWifi;
  bool enableBtn = false;
  @override
  void initState() {
    context.read<ScanDeviceBloc>().add(ScanDeviceResetState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanDeviceBloc, ScanDeviceState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_sharp,
                          size: 25,
                          color: Color(0xff464646),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Scan Device',
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
                  const Spacer(),
                  if (state is ScanDeviceInitial) ...[
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context
                              .read<ScanDeviceBloc>()
                              .add(ScanDeviceRequestPremission());
                        },
                        icon: const Icon(
                          Icons.search_outlined,
                          size: 50,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          "Scan for available devices",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (state is ScanDevicePremission) ...[
                    if (state.status == 'Refuse') ...[
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "GPS permission has not been granted",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                openAppSettings();
                              },
                              icon: const Icon(
                                Icons.settings,
                                size: 50,
                                color: Colors.blue,
                              ),
                              label: const Text(
                                "Open setting",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (state.status == 'Gps not activated') ...[
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "GPS is not enabled",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              "Please open GPS for Scan!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                context
                                    .read<ScanDeviceBloc>()
                                    .add(ScanDeviceResetState());
                                context
                                    .read<ScanDeviceBloc>()
                                    .add(ScanDeviceRequestPremission());
                              },
                              icon: const Icon(
                                Icons.find_replace_outlined,
                                size: 50,
                                color: Colors.blue,
                              ),
                              label: const Text(
                                "Try scan",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  if (state is ScanDeviceLoading) ...[
                    Row(
                      children: const [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "??ang d?? qu??t thi???t b???, n???u kh??ng th???y thi???t b??? xu???t hi???n, h??y b???m n??t reset ????? kh???i ?????ng l???i.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 500,
                      height: 380,
                      // color: Colors.red,
                      child: FlutterRipple(
                        duration: const Duration(milliseconds: 1000),
                        rippleShape: BoxShape.circle,
                        radius: 200,
                        rippleColor: Colors.blue,
                        child: const Icon(
                          Icons.wifi,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                  if (state is ScanDeviceLoaded) ...[
                    Column(
                      children: [
                        const Text(
                          "Danh s??ch thi???t b??? t??m th???y",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: false,
                            itemCount: state.listDevice.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (state.listDevice.isEmpty) {
                                const Text("No device, Try scan!");
                              } else {
                                return TabDeviceComponents(
                                  typeDevice:
                                      state.listDevice[index].typeDevice,
                                  nameDevice:
                                      state.listDevice[index].nameDevice,
                                );
                              }
                              return const Text("erre?");
                            },
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            context
                                .read<ScanDeviceBloc>()
                                .add(ScanDeviceResetState());
                            context
                                .read<ScanDeviceBloc>()
                                .add(ScanDeviceRequestPremission());
                          },
                          icon: const Icon(
                            Icons.find_replace_outlined,
                            size: 50,
                            color: Colors.blue,
                          ),
                          label: const Text(
                            "Try scan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (state is ScanDeviceLoadedNull) ...[
                    Column(
                      children: [
                        const Text(
                          'Device not found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Please check or reset device!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            context
                                .read<ScanDeviceBloc>()
                                .add(ScanDeviceResetState());
                            context
                                .read<ScanDeviceBloc>()
                                .add(ScanDeviceRequestPremission());
                          },
                          icon: const Icon(
                            Icons.find_replace_outlined,
                            size: 50,
                            color: Colors.blue,
                          ),
                          label: const Text(
                            "Try scan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                  if (state is ScanDeviceSetupDevice) ...[
                    Text(
                      'C??i ?????t thi???t b???: ${state.nameDevice}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "L???a ch???n wifi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: CustomDropdownButton2(
                        hint: 'Select wifi',
                        dropdownItems: state.listWifi,
                        value: selectedValueWifi,
                        onChanged: (value) {
                          enableBtn = true;
                          setState(() {
                            selectedValueWifi = value;
                            log(selectedValueWifi.toString());
                          });
                        },
                      ),
                    ),
                    const Text(
                      "Nh???p m???t kh???u",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        controller: _passWifi,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: enableBtn
                                ? () {
                                    context.read<ScanDeviceBloc>().add(
                                        ScanDeviceConnect(
                                            widget.pathEmailRequest,
                                            state.nameDevice,
                                            selectedValueWifi!,
                                            _passWifi.text));
                                  }
                                : null,
                            child: const Text("K???t n???i t???i thi???t b???"),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<ScanDeviceBloc>().add(
                                  const ScanDeviceReturnState(
                                      "ScanDeviceLoaded"));
                            },
                            icon: const Icon(Icons.keyboard_return_outlined),
                            label: const Text("Tr??? L???i"),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (state is ScanDeviceSetupDeviceStatus) ...[
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            '??ang ?????i thi???t b??? ????ng k??...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<ScanDeviceBloc>().add(
                                    const ScanDeviceReturnState(
                                        "ScanDeviceSetupDevice"),
                                  );
                            },
                            icon: const Icon(Icons.keyboard_return_outlined),
                            label: const Text("Tr??? L???i"),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (state is ScanDeviceSetupDeviceStatusSuccsec) ...[
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Thi???t b??? ???? ????ng k?? th??nh c??ng!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Y??u c???u tho??t ???ng d???ng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            '????? c???p nh???p l???i',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context)
                                  .goNamed(RouteNames.dashBoard);
                              SystemNavigator.pop();
                            },
                            // child: const Text("Tr??? v??? m??n h??nh ch??nh"),
                            child: const Text("Tho??t ???ng d???ng"),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (state is ScanDeviceSetupDeviceStatusFails) ...[
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "????ng k?? thi???t b??? th???t b???i!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "Thi???t b??? k???t n???i m???ng kh??ng th??nh c??ng, vui l??ng ki???m tra l???i",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<ScanDeviceBloc>().add(
                                    const ScanDeviceReturnState(
                                        "ScanDeviceSetupDevice"),
                                  );
                            },
                            icon: const Icon(Icons.keyboard_return_outlined),
                            label: const Text("Tr??? L???i"),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (state is ScanDeviceInitial ||
                            state is ScanDevicePremission ||
                            state is ScanDeviceLoading) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                              Text("   "),
                              Text(
                                "2",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "3",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "4",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "D?? qu??t thi???t b???",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                        if (state is ScanDeviceLoaded) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "2",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                              Text("   "),
                              Text(
                                "3",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "4",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "L???a ch???n thi???t b???",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                        if (state is ScanDeviceSetupDevice) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "2",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "3",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                              Text("   "),
                              Text(
                                "4",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "C???u H??nh thi???t b???",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                        if (state is ScanDeviceSetupDeviceStatus ||
                            state is ScanDeviceSetupDeviceStatusSuccsec ||
                            state is ScanDeviceSetupDeviceStatusFails) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "2",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "3",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text("   "),
                              Text(
                                "4",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                          const Text(
                            "????ng k?? thi???t b???",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 50)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
