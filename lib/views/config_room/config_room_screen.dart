import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/views/config_room/components/dialog_change_name_room.dart';
import 'package:smarthome_byme/views/config_room/components/dialog_delete_room.dart';

class ConfigRoomScreen extends StatefulWidget {
  final String pathEmailRequest;
  final String typeUser;
  const ConfigRoomScreen(
      {super.key, required this.pathEmailRequest, required this.typeUser});

  @override
  State<ConfigRoomScreen> createState() => _ConfigRoomScreenState();
}

class _ConfigRoomScreenState extends State<ConfigRoomScreen> {
  late String textFieldAddRoom;
  final _text = TextEditingController();
  bool _validate = false;
  bool _enableButton = false;
  bool maxCountRoom = false;
  late String pathRoom;
  late String pathInfor;
  final List<String> listRoom = [];
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pathRoom = "admin/${widget.pathEmailRequest}/Room/";
    pathInfor = "admin/${widget.pathEmailRequest}/Infor/";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(RouteNames.dashBoard);
                      },
                      icon: const Icon(
                        Icons.arrow_back_sharp,
                        size: 25,
                        color: Color(0xff464646),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Config Room',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.black45)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter new name room:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextField(
                            maxLength: 15,
                            controller: _text,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Ex: Phòng khách',
                              errorText:
                                  _validate ? 'Phòng này đã tổn tại!' : null,
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.cyan,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.cyan,
                                  width: 2,
                                ),
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
                          ElevatedButton(
                            onPressed: _enableButton
                                ? () async {
                                    if (maxCountRoom == true) {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                          'Đã đạt giới hạn phòng, vui lòng nâng cấp gói dịch vụ!',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        backgroundColor: Colors.teal[100],
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      bool flag = false;
                                      for (int i = 0;
                                          i < listRoom.length;
                                          i++) {
                                        if (listRoom[i] == textFieldAddRoom) {
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

                                        DatabaseReference ref = FirebaseDatabase
                                            .instance
                                            .ref(pathRoom);
                                        await ref.update(
                                          {
                                            _text.text: '',
                                          },
                                        );
                                        _text.clear();
                                        setState(() {
                                          _enableButton = false;
                                        });
                                      }
                                    }
                                  }
                                : null,
                            child: const Text(
                              "Thêm phòng",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref(pathRoom)
                      .onValue
                      .asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final room = (snapshot.data!).snapshot.value
                          as Map<dynamic, dynamic>;
                      int countRoom = room.keys.length;
                      if (widget.typeUser == "Test User") {
                        if (countRoom >= 3) {
                          maxCountRoom = true;
                        } else {
                          maxCountRoom = false;
                        }
                      }
                      return Text(
                        "Tổng số phòng: $countRoom",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return const Text(
                      "Tổng số phòng: Loading...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                if (widget.typeUser == "Test User") ...[
                  const Text(
                    "Khả dụng: 3",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (widget.typeUser == "Family") ...[
                  const Text(
                    "Khả dụng: 10",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (widget.typeUser == "Enterprise") ...[
                  const Text(
                    "Khả dụng: 100",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (widget.typeUser == "Unlimited") ...[
                  const Text(
                    "Khả dụng: Unlimited",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const Divider(height: 3, color: Colors.black),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5.0),
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.black45)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "List rooms available:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Column(
                        children: [
                          StreamBuilder(
                            stream: FirebaseDatabase.instance
                                .ref(pathRoom)
                                .onValue
                                .asBroadcastStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                listRoom.clear();
                                try {
                                  final dataRoom = (snapshot.data!)
                                      .snapshot
                                      .value as Map<dynamic, dynamic>;

                                  dataRoom.forEach(
                                    (key, values) {
                                      listRoom.add(key);
                                    },
                                  );
                                } catch (e) {
                                  listRoom.clear();
                                }
                                if (listRoom.isEmpty) {
                                  return const Center(
                                      child: Text(
                                    "Empty! ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ));
                                }
                                return SizedBox(
                                  width: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: listRoom.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        child: Row(
                                          children: [
                                            const Spacer(flex: 1),
                                            Text(
                                              listRoom[index],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const Spacer(flex: 10),
                                            PopupMenuButton(
                                              icon: const Icon(
                                                Icons.more_horiz,
                                                color: Color(0xff464646),
                                              ),
                                              iconSize: 30,
                                              enabled: true,
                                              itemBuilder: (BuildContext cxt) =>
                                                  [
                                                PopupMenuItem(
                                                  child: const Text(
                                                      "Change name room"),
                                                  onTap: () {
                                                    Future.delayed(
                                                      const Duration(
                                                          seconds: 0),
                                                      () => showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (_) =>
                                                            DialogChangeNameRoom(
                                                          pathRoom: pathRoom,
                                                          nameRoom:
                                                              listRoom[index],
                                                          listRoom: listRoom,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  child:
                                                      const Text("Delete room"),
                                                  onTap: () {
                                                    Future.delayed(
                                                      const Duration(
                                                          seconds: 0),
                                                      () => showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (_) =>
                                                            DialogDeleteRoom(
                                                                pathRoom:
                                                                    pathRoom,
                                                                nameRoom:
                                                                    listRoom[
                                                                        index]),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const Spacer(flex: 1),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
