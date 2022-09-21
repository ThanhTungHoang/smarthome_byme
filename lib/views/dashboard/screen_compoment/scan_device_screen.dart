import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/BLoC/scan_device/cubit/scan_device_cubit.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/views/dashboard/screen_compoment/tab_device_components.dart';

class ScanDeviceScreen extends StatefulWidget {
  final String pathUser;
  final String countRoom;
  const ScanDeviceScreen(
      {Key? key, required this.pathUser, required this.countRoom})
      : super(key: key);

  @override
  State<ScanDeviceScreen> createState() => _ScanDeviceScreenState();
}

class _ScanDeviceScreenState extends State<ScanDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanDeviceCubit, ScanDeviceState>(
        builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      'Thêm thiết bị',
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
                    child: ElevatedButton(
                      onPressed: () async {
                        context.read<ScanDeviceCubit>().scanDevice();
                        //  BlocProvider.of<LoginCubit>(context).runLogin();
                      },
                      child: const Text("Bắt đầu quét thiết bị"),
                    ),
                  ),
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
                  // const SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Đã tìm thấy ${state.listDevice.length} thiết bị mới!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Flexible(
                      child: ListView.separated(
                        reverse: true,
                        itemCount: state.listDevice.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TabDeviceComponents(
                            typeDevice: state.listDevice[index],
                            listWifi: state.listDevice,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      context.read<ScanDeviceCubit>().scanDevice();
                    },
                    child: const Center(
                      child: Text(
                        "Quét lại",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
                if (state is ScanDeviceError) ...[
                  Center(
                    child: Text(
                      'Có lỗi xảy ra... ${state.error}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      context.read<ScanDeviceCubit>().scanDevice();
                    },
                    child: const Center(
                      child: Text(
                        "Quét lại",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state is ScanDeviceInitial ||
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
                      ]
                    ],
                  ),
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ),
      );
    });
  }
}
