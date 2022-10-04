import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';

class TopMain extends StatefulWidget {
  final String pathEmailRequest;
  final String nameUser;
  final String content;
  final bool checkUnMessenger;
  const TopMain({
    super.key,
    required this.pathEmailRequest,
    required this.nameUser,
    required this.content,
    required this.checkUnMessenger,
  });

  @override
  State<TopMain> createState() => _TopMainState();
}

class _TopMainState extends State<TopMain> {
  late String pathUrlPhoto;
  @override
  Widget build(BuildContext context) {
    pathUrlPhoto = "admin/${widget.pathEmailRequest}/Infor/UrlPhoto";
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                        radius: 30,
                        backgroundImage:
                            AssetImage("assets/images/user_defaut.png"),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(urlPhoto),
                      );
                    }
                  }
                  return const CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        AssetImage("assets/images/user_defaut.png"),
                  );
                },
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.content,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff464646),
                    ),
                  ),
                  Text(
                    widget.nameUser,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff464646),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              GoRouter.of(context).goNamed(
                RouteNames.messenger,
                queryParams: {"pathEmailRequest": widget.pathEmailRequest},
              );
            },
            icon: widget.checkUnMessenger
                ? const Icon(
                    Icons.mark_email_unread_outlined,
                    color: Colors.blue,
                    size: 30,
                  )
                : const Icon(
                    Icons.email_outlined,
                    color: Colors.blue,
                    size: 30,
                  ),
          ),
        ],
      ),
    );
  }
}
