import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthome_byme/models/messenger/messenger_model.dart';

class DashBoardRepository {
  final storage = const FlutterSecureStorage();
  final ref = FirebaseDatabase.instance.ref();

  final find = '.';
  final replaceWith = '_';
  final List<Messenger> messenger = [];
  bool unMessages = false;
  late final String userName;
  String urlPhoto = '';
  Future<String> getInforUser() async {
    String? pathEmailRequest = await storage.read(key: "pathEmailRequest");
    String? emailUser = await storage.read(key: "emailUser");
    String? nameUser = await storage.read(key: "nameUser");
    return "$pathEmailRequest*$emailUser*$nameUser";
  }

  Future<String> getTypeUser() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    final pathEmail = email!.replaceAll(find, replaceWith);
    final responseTypeUser =
        await ref.child('admin/$pathEmail/Infor/Type').get();
    final String typeUser = responseTypeUser.value.toString();
    return typeUser;
  }

  Future<bool> checkUnMessenger() async {
    final email = FirebaseAuth.instance.currentUser?.email;
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

  Future<List> getListRoom() async {
    final List listRoom = [];
    final email = FirebaseAuth.instance.currentUser?.email;
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
