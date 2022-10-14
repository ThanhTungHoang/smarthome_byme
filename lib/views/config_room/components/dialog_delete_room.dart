import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_byme/generated/l10n.dart';

class DialogDeleteRoom extends StatefulWidget {
  final String pathRoom;
  final String nameRoom;
  const DialogDeleteRoom(
      {Key? key, required this.pathRoom, required this.nameRoom})
      : super(key: key);

  @override
  State<DialogDeleteRoom> createState() => _DialogDeleteRoomState();
}

class _DialogDeleteRoomState extends State<DialogDeleteRoom> {
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
            S.of(context).warning,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            S.of(context).are_y_want_delete,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${widget.nameRoom}?",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  FirebaseDatabase.instance
                      .ref('${widget.pathRoom}/${widget.nameRoom}/')
                      .remove();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: Text(
                  S.of(context).delete,
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
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
                    fontSize: 16,
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
