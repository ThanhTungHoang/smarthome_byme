import 'package:flutter/material.dart';

class DialogChangeInforUser extends StatefulWidget {
  const DialogChangeInforUser({super.key});

  @override
  State<DialogChangeInforUser> createState() => _DialogChangeInforUserState();
}

class _DialogChangeInforUserState extends State<DialogChangeInforUser> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      content: Column(
        children: [],
      ),
    );
  }
}
