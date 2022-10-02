import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DialogSelectionRoom extends StatefulWidget {
  final String pathDevice;
  final String pathRoom;
  final String idDevice;
  const DialogSelectionRoom({
    super.key,
    required this.pathDevice,
    required this.idDevice,
    required this.pathRoom,
  });

  @override
  State<DialogSelectionRoom> createState() => _DialogSelectionRoomState();
}

class _DialogSelectionRoomState extends State<DialogSelectionRoom> {
  bool validate = false;
  bool _enableButton = false;
  List<String> listRoom = [];
  List<bool> value = [];
  int count = 0;
  String room = "";
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
            "Selection room:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200.0,
            width: 300.0,
            child: StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref(widget.pathRoom)
                    .onValue
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listRoom.clear();
                    try {
                      final dataRoom = (snapshot.data!).snapshot.value
                          as Map<dynamic, dynamic>;

                      dataRoom.forEach(
                        (key, values) {
                          listRoom.add(key);
                          value.add(false);
                        },
                      );
                    } catch (e) {
                      listRoom.clear();
                    }
                    if (listRoom.isEmpty) {
                      return const Center(child: Text("Empty room!"));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: listRoom.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            const Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                            CheckboxListTile(
                              side: const BorderSide(color: Colors.red),
                              title: Text(listRoom[index]),
                              autofocus: false,
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              selected: value[index],
                              value: value[index],
                              onChanged: (valueOnChanged) {
                                value[index] = valueOnChanged!;
                                count = 0;
                                _enableButton = false;
                                for (int i = 0; i < value.length; i++) {
                                  if (value[i] == true) {
                                    count++;
                                    if (count == 1) {
                                      room = listRoom[index];
                                      _enableButton = true;
                                      setState(() {});
                                    } else {
                                      _enableButton = false;
                                      setState(() {});
                                    }
                                  }
                                }

                                setState(() {});
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
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

                        if (flag == true) {
                          setState(() {
                            validate = true;
                          });
                        } else {
                          setState(() {
                            validate = false;
                          });
                        }
                        log(room);
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("${widget.pathDevice}/${widget.idDevice}");
                        await ref.update(
                          {
                            "room": room,
                          },
                        );
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
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  DatabaseReference ref = FirebaseDatabase.instance
                      .ref("${widget.pathDevice}/${widget.idDevice}");
                  await ref.update(
                    {
                      "room": '',
                    },
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text(
                  "Remove room",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff464646),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
