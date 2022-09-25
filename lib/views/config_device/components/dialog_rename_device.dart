import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_byme/models/device/device_model.dart';

class DialogReNameDevice extends StatefulWidget {
  final String pathDevice;
  final String idDevice;
  final List<Device> listDevice;
  const DialogReNameDevice(
      {super.key,
      required this.pathDevice,
      required this.idDevice,
      required this.listDevice});

  @override
  State<DialogReNameDevice> createState() => _DialogReNameDeviceState();
}

class _DialogReNameDeviceState extends State<DialogReNameDevice> {
  late String textFieldChangeNameDevice;
  final _text = TextEditingController();
  bool _validate = false;
  bool _enableButton = false;
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
            "Enter a new name",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            maxLength: 15,
            controller: _text,
            decoration: InputDecoration(
              errorText: _validate ? 'Name already exists!' : null,
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            onChanged: ((value) {
              textFieldChangeNameDevice = value;
              if (value.isNotEmpty) {
                setState(() {
                  _enableButton = true;
                });
              } else {
                setState(() {
                  _enableButton = false;
                });
              }
            }),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _enableButton
                    ? () async {
                        bool flag = false;
                        for (int i = 0; i < widget.listDevice.length; i++) {
                          if (widget.listDevice[i].nameDevice ==
                              textFieldChangeNameDevice) {
                            flag = true;
                          }
                        }
                        if (flag == true) {
                          setState(() {
                            _validate = true;
                          });
                        } else {
                          setState(() {
                            _validate = false;
                          });

                          DatabaseReference ref = FirebaseDatabase.instance
                              .ref("${widget.pathDevice}${widget.idDevice}");
                          await ref.update(
                            {
                              "nameDevice": _text.text,
                            },
                          );
                        }
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text(
                  "Rename",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xffffffff),
                  side: const BorderSide(color: Color(0xffBDBDBD), width: 1),
                ),
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
