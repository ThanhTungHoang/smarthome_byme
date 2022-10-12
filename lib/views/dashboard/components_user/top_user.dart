import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smarthome_byme/generated/l10n.dart';

class TopUser extends StatefulWidget {
  final String pathEmailRequest;
  final String nameUser;
  final String typeUser;
  const TopUser(
      {super.key,
      required this.pathEmailRequest,
      required this.nameUser,
      required this.typeUser});

  @override
  State<TopUser> createState() => _TopUserState();
}

class _TopUserState extends State<TopUser> {
  late String pathDevice;
  late String pathRoom;
  late String pathInfor;
  late String pathUrlPhoto;
  @override
  Widget build(BuildContext context) {
    pathDevice = "admin/${widget.pathEmailRequest}/Device/";
    pathRoom = "admin/${widget.pathEmailRequest}/Room/";
    pathInfor = "admin/${widget.pathEmailRequest}/Infor/";
    pathUrlPhoto = "admin/${widget.pathEmailRequest}/Infor/UrlPhoto";
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .ref(pathUrlPhoto)
                        .onValue
                        .asBroadcastStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final String urlPhoto =
                            (snapshot.data!).snapshot.value.toString();

                        if (urlPhoto == "") {
                          return const CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                AssetImage("assets/images/user_defaut.png"),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(urlPhoto),
                          );
                        }
                      }
                      return const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage("assets/images/user_defaut.png"),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: InkWell(
                      onTap: () async {
                        final String avatarName =
                            "${widget.pathEmailRequest}.jpg";
                        final storageRef = FirebaseStorage.instance.ref();
                        final avatarRef = storageRef.child(avatarName);
                        final ImagePicker picker = ImagePicker();

                        await Permission.photos.request();
                        var permissionStatus = await Permission.photos.status;

                        if (permissionStatus.isGranted) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          var file = File(image!.path);
                          log(image.path);
                          // ignore: unnecessary_null_comparison
                          if (image != null) {
                            try {
                              await avatarRef.putFile(file);
                            } on FirebaseException catch (e) {
                              log(e.message.toString());
                            }
                          } else {
                            log('No Image Path Received');
                          }
                          final urlPhotoLink = await avatarRef.getDownloadURL();
                          if (urlPhotoLink.isNotEmpty) {
                            log(urlPhotoLink);
                            DatabaseReference ref =
                                FirebaseDatabase.instance.ref(pathInfor);
                            await ref.update(
                              {
                                "UrlPhoto": urlPhotoLink,
                              },
                            );
                          }
                        } else {
                          log('Permission not granted. Try Again with permission access');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                50,
                              ),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(2, 4),
                                color: Colors.black.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 3,
                              ),
                            ]),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(width: 15),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.nameUser,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.edit,
                        color: Colors.cyan[400],
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 237,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.pathEmailRequest,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: S.of(context).type_service,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w300),
                    children: <InlineSpan>[
                      const TextSpan(
                        text: ": ",
                      ),
                      TextSpan(
                        text: widget.typeUser,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref(pathDevice)
                      .onValue
                      .asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final device = (snapshot.data!).snapshot.value
                          as Map<dynamic, dynamic>;

                      String countDevice = device.keys.length.toString();
                      if (widget.typeUser == "Test User") {
                        return Text.rich(
                          TextSpan(
                            text: S.of(context).number_device_installed,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: ": ",
                              ),
                              TextSpan(
                                text: "$countDevice /3",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        );
                      }
                      if (widget.typeUser == "Family") {
                        return Text.rich(
                          TextSpan(
                            text: S.of(context).number_device_installed,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: ": ",
                              ),
                              TextSpan(
                                text: "$countDevice /10",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        );
                      }
                      if (widget.typeUser == "Enterprise") {
                        return Text.rich(
                          TextSpan(
                            text: S.of(context).number_device_installed,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: ": ",
                              ),
                              TextSpan(
                                text: "$countDevice /100",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        );
                      }
                      if (widget.typeUser == "Unlimited") {
                        return Text.rich(
                          TextSpan(
                            text: S.of(context).number_device_installed,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: ": ",
                              ),
                              TextSpan(
                                text: "$countDevice /Unlimited",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        );
                      }
                    }
                    return const Text(
                      "Loading...",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    );
                  },
                ),
                const SizedBox(height: 5),
                StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref(pathRoom)
                      .onValue
                      .asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final room = (snapshot.data!).snapshot.value
                          as Map<dynamic, dynamic>;

                      String countRoom = room.keys.length.toString();
                      if (widget.typeUser == "Test User") {
                        return Text.rich(
                          TextSpan(
                            text: S.of(context).number_room_installed,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: ": ",
                              ),
                              TextSpan(
                                text: "$countRoom /3",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        );
                      }
                      if (widget.typeUser == "Family") {
                        return Text.rich(
                          TextSpan(
                            text: S.of(context).number_room_installed,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: ": ",
                              ),
                              TextSpan(
                                text: "$countRoom /10",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        );
                      }
                      if (widget.typeUser == "Enterprise") {
                        return Text.rich(
                          TextSpan(
                            text: S.of(context).number_room_installed,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: ": ",
                              ),
                              TextSpan(
                                text: "$countRoom /100",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        );
                      }
                      if (widget.typeUser == "Unlimited") {
                        return Text.rich(
                          TextSpan(
                            text: S.of(context).number_room_installed,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: ": ",
                              ),
                              TextSpan(
                                text: "$countRoom /Unlimited",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        );
                      }
                    }
                    return const Text(
                      "Loading...",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
