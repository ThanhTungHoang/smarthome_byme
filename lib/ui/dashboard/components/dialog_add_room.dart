import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';

class DialogAddRoom extends StatefulWidget {
  final String path;
  final List<String> nameRoom;
  const DialogAddRoom({Key? key, required this.path, required this.nameRoom})
      : super(key: key);

  @override
  State<DialogAddRoom> createState() => _DialogAddRoomState();
}

// setState
// Only rebuild dialog, not rebuild all screen
class _DialogAddRoomState extends State<DialogAddRoom> {
  late String textFieldAddRoom;
  final _text = TextEditingController();
  bool _validate = false;
  bool _enableButton = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      title: const Text(
        "Thêm phòng",
        style: TextStyle(
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
            const Text(
              "Nhập tên phòng: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLength: 20,
              controller: _text,
              decoration: InputDecoration(
                labelText: 'Ex: Phòng khách',
                errorText: _validate ? 'Phòng này đã tổn tại!' : null,
              ),
              onChanged: ((value) {
                textFieldAddRoom = value;
                if (value.isNotEmpty) {
                  // Only rebuild dialog, not rebuild all screen
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _enableButton
                      ? () async {
                          bool flag = false;
                          for (int i = 0; i < widget.nameRoom.length; i++) {
                            if (widget.nameRoom[i] == textFieldAddRoom) {
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
                                .ref("${widget.path}/Room/");
                            await ref.update(
                              {
                                _text.text: '',
                              },
                            );

                            // ignore: use_build_context_synchronously
                            GoRouter.of(context)
                                .pushNamed(RouteNames.dashBoard);
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xff4271EA),
                    ),
                  ),
                  child: const Text(
                    "Lưu thay đổi",
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
