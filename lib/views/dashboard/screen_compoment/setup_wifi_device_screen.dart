// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:dropdown_textfield/dropdown_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';

// class SetupWifiDeviceScreen extends StatefulWidget {
//   final String nameDevice;
//   final List wifiSelect;
//   const SetupWifiDeviceScreen(
//       {Key? key, required this.nameDevice, required this.wifiSelect})
//       : super(key: key);

//   @override
//   State<SetupWifiDeviceScreen> createState() => _SetupWifiDeviceScreenState();
// }

// class _SetupWifiDeviceScreenState extends State<SetupWifiDeviceScreen> {
//   final SingleValueDropDownController _ssidWifi =
//       SingleValueDropDownController();
//   final TextEditingController _passWifi = TextEditingController();
//   final List<DropDownValueModel> _listWifi = [];
//   List<String> _wifiSelect = [];
//   @override
//   void initState() {
//     super.initState();
//     final str = widget.wifiSelect[0]
//         .substring(0, widget.wifiSelect[0].length - 1)
//         .trim();
//     final listStr = str.substring(1);
//     log(listStr);
//     _wifiSelect = listStr.split(', ');
//     log(_wifiSelect.toString());
//     for (int i = 0; i < _wifiSelect.length; i++) {
//       _listWifi.add(
//         DropDownValueModel(
//           name: _wifiSelect[i],
//           value: _wifiSelect[i],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       GoRouter.of(context).pop();
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back_sharp,
//                       size: 25,
//                       color: Color(0xff464646),
//                     ),
//                   ),
//                   const Spacer(),
//                   const Text(
//                     'Thêm thiết bị',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const Spacer(),
//                   const SizedBox(
//                     width: 50,
//                     height: 50,
//                   ),
//                 ],
//               ),
//               //////////////////
//               Text(
//                 'Cài đặt thiết bị: ${widget.nameDevice}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Lựa chọn wifi",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               DropDownTextField(
//                 controller: _ssidWifi,
//                 // singleController: _ssidWifi,
//                 clearOption: false,
//                 enableSearch: true,
//                 validator: (value) {
//                   log(value.toString());
//                   if (value == null) {
//                     return "Required field";
//                   } else {
//                     return null;
//                   }
//                 },
//                 dropDownItemCount: 6,
//                 dropDownList: _listWifi,
//                 onChanged: (val) {
//                   log(val);
//                 },
//               ),
//               const Text(
//                 "Nhập mật khẩu",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _passWifi,
//               ),
//               //////////////
//               Text("add wifi device: ${widget.nameDevice}"),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     final status =
//                         await PluginWifiConnect.connect(widget.nameDevice);
//                     if (status == true) {
//                       log("connect sucssec");
//                       var ip = InternetAddress("192.168.4.1");
//                       int port = 4210;

//                       RawDatagramSocket.bind(InternetAddress.anyIPv4, port)
//                           .then((RawDatagramSocket udpSocket) {
//                         udpSocket.broadcastEnabled = true;
//                         udpSocket.listen((e) {
//                           Datagram? dg = udpSocket.receive();
//                           if (dg != null) {
//                             String s = String.fromCharCodes(dg.data);
//                             log("received $s");
//                           }
//                         });
//                         List<int> data = utf8.encode(
//                             "${_ssidWifi.dropDownValue!.name}-${_passWifi.text}-user");
//                         udpSocket.send(data, ip, port);
//                       });
//                     } else {
//                       log("fails");
//                     }
//                   },
//                   child: const Text("Kết nối tới thiết bị"),
//                 ),
//               ),
//               const Spacer(),
//               Center(
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const <Widget>[
//                         Text(
//                           "1",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xffBDBDBD),
//                           ),
//                         ),
//                         Text("   "),
//                         Text(
//                           "2",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xffBDBDBD),
//                           ),
//                         ),
//                         Text("   "),
//                         Text(
//                           "3",
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.blue),
//                         ),
//                       ],
//                     ),
//                     const Text(
//                       "Đăng ký thiết bị",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     const SizedBox(height: 50)
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
