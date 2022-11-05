import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DialogDeleteDevice extends StatefulWidget {
  final String pathDevice;
  final String idDevice;
  const DialogDeleteDevice(
      {super.key, required this.pathDevice, required this.idDevice});

  @override
  State<DialogDeleteDevice> createState() => _DialogDeleteDeviceState();
}

class _DialogDeleteDeviceState extends State<DialogDeleteDevice> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Are you sure you want to delete?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () async {
                  DatabaseReference ref =
                      FirebaseDatabase.instance.ref("${widget.pathDevice}/${widget.idDevice}/");
                  await ref.remove();
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff464646),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
