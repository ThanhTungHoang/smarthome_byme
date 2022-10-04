import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_byme/core/app_colors.dart';

class DialogSettingDevice extends StatefulWidget {
  final String id;
  final String path;
  final String name;
  final String room;
  const DialogSettingDevice(
      {Key? key,
      required this.path,
      required this.name,
      required this.id,
      required this.room})
      : super(key: key);

  @override
  State<DialogSettingDevice> createState() => _DialogSettingDeviceState();
}

class _DialogSettingDeviceState extends State<DialogSettingDevice> {
  late String textFieldChangeName;
  late String textFieldChangeRoom;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      title: const Text(
        'Chỉnh sửa thiết bị',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: 100,
        height: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.colorBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thông tin thiết bị:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Id thiết bị: ${widget.id}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Tên thiết bị: ${widget.name}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Vị trí phòng thiết bị: ${widget.room}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              color: AppColors.colorBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Lựa chọn chức năng:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          title: const Text('Chỉnh sửa tên thiết bị'),
                          content: SizedBox(
                            width: 100,
                            height: 150,
                            child: Column(
                              children: [
                                Text(widget.name),
                                TextField(
                                  maxLength: 12,
                                  onChanged: ((value1) {
                                    textFieldChangeName = value1;
                                  }),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    log("click");
                                    if (textFieldChangeName != widget.id) {
                                      DatabaseReference ref = FirebaseDatabase
                                          .instance
                                          .ref("${widget.path}/${widget.id}/");
                                      await ref.update(
                                        {
                                          "name": textFieldChangeName,
                                        },
                                      );
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Thay đổi"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text("Thay đổi tên"),
                  ),
                  const SizedBox(height: 3),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          title: const Text('Thay đổi vị trí phòng thiết bị'),
                          content: SizedBox(
                            width: 100,
                            height: 150,
                            child: Column(
                              children: [
                                Text(widget.room),
                                TextField(
                                  maxLength: 12,
                                  onChanged: ((value) {
                                    textFieldChangeRoom = value;
                                  }),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    log("click");
                                    if (textFieldChangeRoom != widget.id) {
                                      DatabaseReference ref = FirebaseDatabase
                                          .instance
                                          .ref("${widget.path}/${widget.id}/");
                                      await ref.update(
                                        {
                                          "room": textFieldChangeRoom,
                                        },
                                      );
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Thay đổi"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text("Thay đổi phòng thiết bị"),
                  ),
                  const SizedBox(height: 3),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text("Xóa thiết bị"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
