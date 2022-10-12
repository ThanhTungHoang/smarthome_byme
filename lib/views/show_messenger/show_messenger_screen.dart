import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/generated/l10n.dart';
import 'package:smarthome_byme/models/messenger/messenger_model.dart';

class ShowMessengerScreen extends StatefulWidget {
  final String pathEmailRequest;
  const ShowMessengerScreen({super.key, required this.pathEmailRequest});

  @override
  State<ShowMessengerScreen> createState() => _ShowMessengerScreenState();
}

class _ShowMessengerScreenState extends State<ShowMessengerScreen> {
  late String pathMessenger;
  final List<Messenger> listMessenger = [];
  @override
  Widget build(BuildContext context) {
    pathMessenger = "admin/${widget.pathEmailRequest}/Messenger/";
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(RouteNames.dashBoard);
                  },
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    size: 25,
                    color: Color(0xff464646),
                  ),
                ),
                const Spacer(),
                Text(
                  S.of(context).mailbox,
                  style: const TextStyle(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance
                      .ref(pathMessenger)
                      .onValue
                      .asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      listMessenger.clear();
                      try {
                        final dataMessenger = (snapshot.data!).snapshot.value
                            as Map<dynamic, dynamic>;

                        dataMessenger.forEach(
                          (key, values) {
                            // print(values);
                            listMessenger.add(
                              Messenger.fromJson(
                                jsonDecode(
                                  jsonEncode(values),
                                ),
                              ),
                            );
                          },
                        );
                      } catch (e) {
                        listMessenger.clear();
                      }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: listMessenger.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (listMessenger[index].seen == true) ...[
                                  const Icon(Icons.check),
                                ],
                                if (listMessenger[index].seen == false) ...[
                                  const Icon(
                                      Icons.notifications_active_outlined),
                                ],
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listMessenger[index].title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      listMessenger[index].content,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (listMessenger[index].seen == true) ...[
                                  TextButton(
                                    onPressed: () async {
                                      DatabaseReference ref =
                                          FirebaseDatabase.instance.ref(
                                              "$pathMessenger/${listMessenger[index].title}");
                                      await ref.update(
                                        {
                                          "seen": false,
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "Mark as unread",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                                if (listMessenger[index].seen == false) ...[
                                  TextButton(
                                    onPressed: () async {
                                      DatabaseReference ref =
                                          FirebaseDatabase.instance.ref(
                                              "$pathMessenger/${listMessenger[index].title}");
                                      await ref.update(
                                        {
                                          "seen": true,
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "Mark read",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                          // return ListTile(
                          //   // contentPadding: const EdgeInsets.only(bottom: 5),
                          //   isThreeLine: true,
                          //   leading:
                          //       const Icon(Icons.notifications_none_rounded),
                          //   trailing: const Text(
                          //     "GFG",
                          //     style:
                          //         TextStyle(color: Colors.green, fontSize: 15),
                          //   ),
                          //   title: Text(listMessenger[index].title),
                          //   subtitle: Text(listMessenger[index].content),
                          // );
                        },
                      );
                    }

                    return const Text("hih");
                  },
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
