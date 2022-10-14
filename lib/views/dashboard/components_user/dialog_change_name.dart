import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthome_byme/generated/l10n.dart';

class DialogChangeName extends StatefulWidget {
  final String pathEmailRequest;

  const DialogChangeName({
    Key? key,
    required this.pathEmailRequest,
  }) : super(key: key);

  @override
  State<DialogChangeName> createState() => _DialogChangeNameState();
}

class _DialogChangeNameState extends State<DialogChangeName> {
  late String textFieldValue;
  final _text = TextEditingController();
  late String pathInfor;
  bool _enableButton = false;
  @override
  Widget build(BuildContext context) {
    pathInfor = "admin/${widget.pathEmailRequest}/Infor/";
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
          Text(
            S.of(context).enter_new_name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            maxLength: 16,
            controller: _text,
            decoration: const InputDecoration(
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            onChanged: ((value) {
              textFieldValue = value;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _enableButton
                    ? () async {
                        const storage = FlutterSecureStorage();
                        DatabaseReference ref =
                            FirebaseDatabase.instance.ref(pathInfor);
                        await ref.update(
                          {
                            "Name": _text.text,
                          },
                        );
                        await storage.write(key: "nameUser", value: _text.text);
                      }
                    : null,
                child: Text(
                  S.of(context).change,
                  style: const TextStyle(
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
                child: Text(
                  S.of(context).cancel,
                  style: const TextStyle(
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
