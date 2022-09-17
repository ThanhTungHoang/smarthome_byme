import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';

class DialogDeleteRoom extends StatefulWidget {
  final String path;
  final String nameRoom;
  const DialogDeleteRoom({Key? key, required this.path, required this.nameRoom})
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
      title: const Text(
        "Cảnh báo!!!",
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: 100,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Xóa: ${widget.nameRoom}",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "Hành động này sẽ không ảnh hưởng đến thiết bị đã được kết nối! ",
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Vui lòng xác nhận:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    FirebaseDatabase.instance
                        .ref('${widget.path}/${widget.nameRoom}/')
                        .remove();
                    // ignore: use_build_context_synchronously
                    GoRouter.of(context).pushNamed(RouteNames.dashBoard);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text(
                    "Xóa phòng",
                    style: TextStyle(
                      fontSize: 15,
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
                  child: const Text(
                    "Trở lại",
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
      ),
    );
  }
}
