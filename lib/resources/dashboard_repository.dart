import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smarthome_byme/models/messenger/messenger_model.dart';

class DashBoardRepository {
  final ref = FirebaseDatabase.instance.ref();
  final email = FirebaseAuth.instance.currentUser?.email;
  final find = '.';
  final replaceWith = '_';
  final List<Messenger> messenger = [];
  bool unMessages = false;
  late final String userName;

  Future<bool> checkUnMessenger() async {
    final pathEmail = email!.replaceAll(find, replaceWith);
    try {
      final notificationRawData =
          await ref.child('admin/$pathEmail/Messenger/').get();
      final notificationDaTa =
          notificationRawData.value as Map<dynamic, dynamic>;
      notificationDaTa.forEach(
        (key, values) {
          messenger.add(
            Messenger.fromJson(
              jsonDecode(
                jsonEncode(values),
              ),
            ),
          );
        },
      );
    } catch (e) {
      return unMessages;
    }

    for (int i = 0; i < messenger.length; i++) {
      if (messenger[i].seen == false) {
        unMessages = true;
      }
    }
    return unMessages;
  }

  Future getUserName() async {
    final pathEmail = email!.replaceAll(find, replaceWith);

    final response = await ref.child('admin/$pathEmail/Infor/Name').get();
    final userName = response.value;
    if (userName == null) {
      return "User";
    } else {
      return userName;
    }
  }

  Future getPathEmailRequest() async {
    final pathEmail = email!.replaceAll(find, replaceWith);
    return pathEmail;
  }

  Future<List> getListRoom() async {
    final List listRoom = [];

    final pathEmail = email!.replaceAll(find, replaceWith);
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('admin/$pathEmail/Room');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach(
        (key, values) {
          listRoom.add(key);
        },
      );
    });
    return listRoom;
  }
}
