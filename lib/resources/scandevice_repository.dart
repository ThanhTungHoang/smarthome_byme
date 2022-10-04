import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';

class ScanDeviceRepository {
  Stream<String> sendValueToEndDevice(String nameDevice, String ssidWifi,
      String passWifi, String pathEmailRequest) async* {
    final status = await PluginWifiConnect.connect(nameDevice);
    // await PluginWifiConnect.disconnect();
    log("go send value to end device");
    if (status == true) {
      log("connect_device_done");
      // yield "connect_device_done";
      var ip = InternetAddress("192.168.4.1");
      int port = 4210;

      RawDatagramSocket.bind(InternetAddress.anyIPv4, port).then(
        (RawDatagramSocket udpSocket) async* {
          udpSocket.broadcastEnabled = true;
          udpSocket.readEventsEnabled = true;

          yield "1";

          // ignore: void_checks
          udpSocket.listen((e) async* {
            Datagram? dg = udpSocket.receive();
            if (dg != null) {
              String s = String.fromCharCodes(dg.data);
              log("received..... $s");
              if (s == "S") {
                log("statusSucssec = true");
                yield "setup_done";
              }
              if (s == "F") {
                log("statusFails = false");
                yield "setup_fail";
              }
            }
          });

          List<int> data = utf8.encode("$ssidWifi-$passWifi-$pathEmailRequest");
          udpSocket.send(data, ip, port);
        },
      );
    } else {
      log("connect_device_fail");
     
    }
    //  yield "end future";
  }
  
  //   Future<Stream<String>> sendValueToEndDevice1(String nameDevice, String ssidWifi,
  //     String passWifi, String pathEmailRequest)  async {
  //           var multicastEndpoint =
  //       Endpoint.multicast(InternetAddress("239.1.2.3"), port: const Port(54321));

  //   var receiver = await UDP.bind(multicastEndpoint);

  //   var sender = await UDP.bind(Endpoint.any());

  //   receiver.asStream().listen((datagram) sync*{
  //     if (datagram != null) {
  //       var str = String.fromCharCodes(datagram.data);
  // yield "connect_device_fail";
  //       stdout.write(str);
  //     }
  //   });

  //   await sender.send("Foo".codeUnits, multicastEndpoint);

  //   await Future.delayed(Duration(seconds:5));

  //   sender.close();
  //   receiver.close();
  //     }
}
