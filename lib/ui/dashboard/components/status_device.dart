import 'dart:async';
import 'package:flutter/material.dart';

class StatusDevice extends StatefulWidget {
  final int ping;
  const StatusDevice({
    super.key,
    required this.ping,
  });

  @override
  State<StatusDevice> createState() => _StatusDeviceState();
}

class _StatusDeviceState extends State<StatusDevice> {
  int _start = 10;
  bool checkOnline = false;
  late int oldPing;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (_start == 0) {
            if (oldPing == widget.ping) {
              checkOnline = false;
              // print("offline");
              // print(widget.ping);
            } else {
              checkOnline = true;
              oldPing = widget.ping;
              // print("online");
              // print(widget.ping);
            }
          }
          setState(() {
            _start = 10;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    oldPing = widget.ping;
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text("$_start"),
        // Text("${widget.ping}"),
        if (checkOnline == true) ...[
          const Text(
            "Online",
            style: TextStyle(fontSize: 10, color: Colors.green),
          ),
        ],
        if (checkOnline == false) ...[
          const Text(
            "Ofiline",
            style: TextStyle(fontSize: 10, color: Colors.red),
          ),
        ],
      ],
    );
  }
}
