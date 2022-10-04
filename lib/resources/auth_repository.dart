import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthome_byme/models/login/login_model.dart';
import 'package:smarthome_byme/models/signup/signup_model.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  Future<String> signUp(SignUpParam signUpParam) async {
    try {
      final response = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: signUpParam.email, password: signUpParam.password);
      if (response.user?.emailVerified == false) {
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'too-many-requests') {
        return 'too_many_requests';
      }
      if (e.code == 'network-request-failed') {
        return 'network_request_failed';
      }
      if (e.code == 'invalid-email') {
        return 'invalid_email';
      }
      if (e.code == 'email-already-in-use') {
        return "Email_already_in_use";
      }
    }
    return "signup_success";
  }

  Future<String?> signIn(LoginParam loginParam) async {
    try {
      final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginParam.email, password: loginParam.password);
      log(response.toString());
      if (response.user?.emailVerified == false) {
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      }
      final email = FirebaseAuth.instance.currentUser?.email;
      await storage.write(key: "emailUser", value: email);
      final pathEmail = email!.replaceAll('.', '_');
      final ref = FirebaseDatabase.instance.ref();
      final responseName = await ref.child('admin/$pathEmail/Infor/Name').get();
      final String userName = responseName.value.toString();
      await storage.write(key: "pathEmailRequest", value: pathEmail);
      await storage.write(key: "emailUser", value: email);
      await storage.write(key: "nameUser", value: userName);
      // saveInforUser();
      return "login_success-${response.user!.emailVerified.toString()}";
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'user-not-found') {
        return 'user_not_found';
      }
      if (e.code == 'too-many-requests') {
        return 'too_many_requests';
      }
      if (e.code == 'network-request-failed') {
        return 'network_request_failed';
      }
      if (e.code == 'wrong-password') {
        return 'wrong_password';
      }
    }
    return null;
  }

  Future forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'user_not_found';
      }
      if (e.code == 'too-many-requests') {
        return 'too_many_requests';
      }
      if (e.code == 'network-request-failed') {
        return 'network_request_failed';
      }
    }

    return "send_Email_Done";
  }

  Future<String> signOut() async {
    await storage.deleteAll();
    await _firebaseAuth.signOut();
    return "signOut_Done";
  }

  Future createUserData(String fullname) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("admin");
    final email = FirebaseAuth.instance.currentUser?.email;

    const find = '.';
    const replaceWith = '_';
    final pathEmail = email!.replaceAll(find, replaceWith);
    await ref.update(
      {
        pathEmail: {
          "Device": {
            "123Device": {
              "typeDevice": "Switch",
              "nameDevice": "Cong tac",
              "ping": 3,
              "toggle": true,
              "idDevice": "123Device",
              "lock": "",
              "temp": "",
              "humi": "",
              "co2": "",
              "red": "",
              "green": "",
              "blue": "",
              "voltage": "",
              "ampe": "",
              "wat": "",
              "room": "",
            },
          },
          "Room": {
            "Phòng khách": "",
          },
          "Premision": {
            "MaxDevice": 5,
            "MaxRoom": 5,
          },
          "Infor": {
            "Name": fullname,
            "UrlPhoto": '',
          },
          "Messenger": {
            "Welcome new user!": {
              "title": "Welcome new user!",
              "content": "Hi, Thank you for using the app!",
              "seen": false,
            }
          }
        }
      },
    );
  }
}
