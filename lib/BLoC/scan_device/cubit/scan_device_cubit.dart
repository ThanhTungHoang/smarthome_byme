import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_scan/wifi_scan.dart';

part 'scan_device_state.dart';

class ScanDeviceCubit extends Cubit<ScanDeviceState> {
  ScanDeviceCubit() : super(ScanDeviceInitial());

  List<String> listWifi = [];
  List<WiFiAccessPoint> accessPoints = [];

  void startScan() async {
    listWifi.clear();
    await WiFiScan.instance.startScan(askPermissions: true);
    final result =
        await WiFiScan.instance.getScannedResults(askPermissions: true);
    if (result.hasError) {
      emit(ScanDeviceError(result.hasError.toString()));
      log("result.hasError: ${result.hasError}");
    } else {
      accessPoints = result.value!;
      for (int i = 0; i < accessPoints.length; i++) {
        addWifi(accessPoints[i]);
      }
    }
  }

  void addWifi(WiFiAccessPoint ap) {
    listWifi.add(ap.ssid);
    emit(ScanDeviceLoaded(listWifi));
    log("ssid: ${ap.ssid}");
  }

  /////////////
  Future<void> scanDevice() async {
    log("start void scanDevice");
    emit(ScanDeviceLoading());
    await Future.delayed(const Duration(seconds: 2), () {
      // emit(ScanDeviceLoaded("ok"));
      startScan();
    });
  }
}
