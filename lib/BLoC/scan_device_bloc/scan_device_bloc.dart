import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';
import 'package:smarthome_byme/models/device_scan/device_scan_model.dart';
import 'package:smarthome_byme/resources/scandevice_repository.dart';
import 'package:wifi_scan/wifi_scan.dart';

part 'scan_device_event.dart';
part 'scan_device_state.dart';

class ScanDeviceBloc extends Bloc<ScanDeviceEvent, ScanDeviceState> {
  final ScanDeviceRepository scanDeviceRepository;
  ScanDeviceBloc({required this.scanDeviceRepository})
      : super(ScanDeviceInitial()) {
    List<String> listWifi = [];
    List<DeviceScan> listDevice = [];
    List<WiFiAccessPoint> accessPoints = [];
    late String nameDevice;

    on<ScanDeviceResetState>(
      (event, emit) {
        emit(ScanDeviceInitial());
      },
    );
    on<ScanDeviceReturnState>(
      (event, emit) {
        if (event.stateReturn == "ScanDeviceLoaded") {
          emit(ScanDeviceLoaded(listDevice));
        }
        if (event.stateReturn == "ScanDeviceSetupDevice") {
          emit(ScanDeviceSetupDevice(nameDevice, listWifi));
        }
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
        nameDevice = event.nameDevice;
        emit(ScanDeviceSetupDevice(nameDevice, listWifi));
      }),
    );
    on<ScanDeviceConnect>(
      ((event, emit) async {
        final status = await PluginWifiConnect.connect(event.nameDevice);
        // await PluginWifiConnect.disconnect();
        if (status == true) {
          log("connect sucssec");
          emit(const ScanDeviceSetupDeviceStatus(""));
          var ip = InternetAddress("192.168.4.1");
          int port = 4210;

          RawDatagramSocket.bind(InternetAddress.anyIPv4, port).then(
            (RawDatagramSocket udpSocket) async {
              udpSocket.broadcastEnabled = true;
              udpSocket.readEventsEnabled = true;

              udpSocket.asBroadcastStream().listen((e) async {
                Datagram? dg = udpSocket.receive();
                if (dg != null) {
                  String s = String.fromCharCodes(dg.data);
                  log("received..... $s");
                  if (s == "S") {
                    add(ScanDeviceGetStatusDevice(s));
                  }
                  if (s == "F") {
                    add(ScanDeviceGetStatusDevice(s));
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
    on<ScanDeviceGetStatusDevice>(
      (event, emit) {
        log("wait reponse");
        if (event.value == "S") {
          log("Add device doneeeeeeeeeeeeeeeee!");
          emit(const ScanDeviceSetupDeviceStatusSuccsec());
        }
        if (event.value == "F") {
          log("Add device Failllllllllllllllll!");
          emit(const ScanDeviceSetupDeviceStatusFails());
        }
      },
    );
  }
}
