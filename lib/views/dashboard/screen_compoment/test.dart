// import 'dart:async';


// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:wifi_scan/wifi_scan.dart';
// import 'package:wifi_iot/wifi_iot.dart';

// void main() {
//   runApp(const MyApp());
// }

// /// Example app for wifi_scan plugin.
// class MyApp extends StatefulWidget {
//   /// Default constructor for [MyApp] widget.
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final g = WiFiScan.instance;
//   List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
//   List<WiFiAccessPoint> listWifi = [];
//   StreamSubscription<Result<List<WiFiAccessPoint>, GetScannedResultsErrors>>?
//       subscription;
//   void _getScannedResults() async {
//     // get scanned results
//     final result = await WiFiScan.instance.startScan(askPermissions: true);
//     log('-------------');
//     log('result.toString()');
//     log(result.toString());
//     log('-------------');
//     accessPoints.clear();
//     getList();
//   }

//   void getList() async {
//     subscription = WiFiScan.instance.onScannedResultsAvailable.listen((result) {
//       if (result.hasError) {
//         print("errr");
//       } else {
//         accessPoints = result.value!;
//         for (int i = 0; i < accessPoints.length; i++) {
//           get(accessPoints[i]);
//         }
//       }
//     });
//   }

//   void get(WiFiAccessPoint ap) {
//     log(ap.ssid);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: FutureBuilder<bool>(
//           future: WiFiScan.instance.hasCapability(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.data!) {
//               return const Center(child: Text("WiFi scan not supported."));
//             }
//             return Column(
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton.icon(
//                               icon: const Icon(Icons.refresh),
//                               label: const Text('GET'),
//                               // call getScannedResults and handle the result
//                               onPressed: () {
//                                 _getScannedResults();
//                                 // scan();
//                               }),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 StreamBuilder(
//                   stream: WiFiScan.instance
//                       .startScan(askPermissions: true)
//                       .asStream(),
//                   builder: ((context, snapshot) {
//                     log(snapshot.data.toString());
//                     return Text("aa");
//                   }),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// /// Show snackbar.
// void kShowSnackBar(BuildContext context, String message) {
//   if (kDebugMode) print(message);
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(SnackBar(content: Text(message)));
// }
