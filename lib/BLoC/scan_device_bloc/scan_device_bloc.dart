import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';
import 'package:smarthome_byme/models/device_scan/device_scan_model.dart';
import 'package:wifi_scan/wifi_scan.dart';

part 'scan_device_event.dart';
part 'scan_device_state.dart';

class ScanDeviceBloc extends Bloc<ScanDeviceEvent, ScanDeviceState> {
  ScanDeviceBloc() : super(ScanDeviceInitial()) {
    List<String> listWifi = [];
    List<DeviceScan> listDevice = [];
    List<WiFiAccessPoint> accessPoints = [];

    on<ScanDeviceResetState>(
      (event, emit) {
        emit(ScanDeviceInitial());
      },
    );

    on<ScanDeviceRequestPremission>(
      (event, emit) async {
        if (await Permission.location.request().isGranted) {
          if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
            emit(ScanDeviceLoading());

            await Future.delayed(const Duration(seconds: 2), () async {
              void addWifi(WiFiAccessPoint ap) {
                listWifi.add(ap.ssid);

                if (ap.ssid.contains("Switch")) {
                  listDevice.add(DeviceScan(ap.ssid, "Switch"));
                } else if (ap.ssid.contains("Light")) {
                  listDevice.add(DeviceScan(ap.ssid, "Light"));
                }
                if (listDevice.isEmpty) {
                  emit(ScanDeviceLoadedNull());
                  log("null device");
                } else {
                  emit(ScanDeviceLoaded(listDevice));
                  log("listDevice: ${listDevice.length}");
                }
              }

              emit(ScanDeviceLoading());
              listWifi.clear();
              listDevice.clear();
              await WiFiScan.instance.startScan(askPermissions: true);
              final result = await WiFiScan.instance
                  .getScannedResults(askPermissions: true);
              if (result.hasError) {
                emit(ScanDeviceError(result.hasError.toString()));
                log("result.hasError: ${result.hasError}");
              } else {
                accessPoints = result.value!;
                for (int i = 0; i < accessPoints.length; i++) {
                  addWifi(accessPoints[i]);
                }
              }
            });
          } else {
            emit(const ScanDevicePremission("Gps not activated"));
          }
        } else {
          emit(const ScanDevicePremission("Refuse"));
        }
      },
    );
    on<ScanDeviceSetup>(
      ((event, emit) {
        emit(ScanDeviceSetupDevice(event.nameDevice, listWifi));
      }),
    );
    on<ScanDeviceConnect>(
      ((event, emit) async {
        final status = await PluginWifiConnect.connect(event.nameDevice);
        if (status == true) {
          log("connect sucssec");
          emit(const ScanDeviceSetupDeviceStatus(""));
          var ip = InternetAddress("192.168.4.1");
          int port = 4210;

          RawDatagramSocket.bind(InternetAddress.anyIPv4, port).then(
            (RawDatagramSocket udpSocket) {
              udpSocket.broadcastEnabled = true;
              udpSocket.listen((e) {
                Datagram? dg = udpSocket.receive();
                if (dg != null) {
                  String s = String.fromCharCodes(dg.data);
                  log("received $s");
                  if (s == "S") {
                    log("Add device done!");
                    emit(const ScanDeviceSetupDeviceStatus("S"));
                  }
                  if (s == "F") {
                    log("Add device Fail!");
                    emit(const ScanDeviceSetupDeviceStatus("F"));
                  }
                }
              });
              List<int> data = utf8.encode(
                  "${event.ssidWifi}-${event.passWifi}-${event.pathEmailRequest}");
              udpSocket.send(data, ip, port);
            },
          );
        } else {
          log("fails");
        }
      }),
    );
  }
}
