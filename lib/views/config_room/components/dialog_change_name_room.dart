import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_byme/generated/l10n.dart';

class DialogChangeNameRoom extends StatefulWidget {
  final String pathRoom;
  final String nameRoom;
  final List listRoom;
  const DialogChangeNameRoom(
      {Key? key,
      required this.pathRoom,
      required this.nameRoom,
      required this.listRoom})
      : super(key: key);

  @override
  State<DialogChangeNameRoom> createState() => _DialogChangeNameRoomState();
}

class _DialogChangeNameRoomState extends State<DialogChangeNameRoom> {
  late String textFieldAddRoom;
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
          Text(
            S.of(context).enter_new_name_room,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            maxLength: 15,
            controller: _text,
            decoration: InputDecoration(
              errorText:
                  _validate ? S.of(context).this_room_already_exists : null,
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            onChanged: ((value) {
              textFieldAddRoom = value;
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
                        bool flag = false;
                        for (int i = 0; i < widget.listRoom.length; i++) {
                          if (widget.listRoom[i] == textFieldAddRoom) {
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
                          FirebaseDatabase.instance
                              .ref('${widget.pathRoom}/${widget.nameRoom}/')
                              .remove();
                          DatabaseReference ref =
                              FirebaseDatabase.instance.ref(widget.pathRoom);
                          await ref.update(
                            {
                              _text.text: '',
                            },
                          ).then((value) => Navigator.pop(context));
                        }
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
