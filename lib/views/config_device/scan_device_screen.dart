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
                            "Đang dò quét thiết bị, nếu không thấy thiết bị xuất hiện, hãy bấm nút reset để khởi động lại.",
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
                          "Danh sách thiết bị tìm thấy",
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
                      'Cài đặt thiết bị: ${state.nameDevice}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Lựa chọn wifi",
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
                      "Nhập mật khẩu",
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
                            child: const Text("Kết nối tới thiết bị"),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<ScanDeviceBloc>().add(
                                  const ScanDeviceReturnState(
                                      "ScanDeviceLoaded"));
                            },
                            icon: const Icon(Icons.keyboard_return_outlined),
                            label: const Text("Trở Lại"),
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
                            'Đang đợi thiết bị đăng ký...',
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
                            label: const Text("Trở Lại"),
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
                            'Thiết bị đã đăng ký thành công!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Yêu cầu thoát ứng dụng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'để cập nhập lại',
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
                            // child: const Text("Trở về màn hình chính"),
                            child: const Text("Thoát ứng dụng"),
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
                            "Đăng ký thiết bị thất bại!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "Thiết bị kết nối mạng không thành công, vui lòng kiểm tra lại",
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
                            label: const Text("Trở Lại"),
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
                            "Dò quét thiết bị",
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
                            "Lựa chọn thiết bị",
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
                            "Cấu Hình thiết bị",
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
                            "Đăng ký thiết bị",
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
