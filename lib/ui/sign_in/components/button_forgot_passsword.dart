import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../forgot_password/forgot_password_screen.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          const SizedBox(),
          const Spacer(),
          InkWell(
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: ((BuildContext context) {
                    return const ForgotPasswordScreen();
                  }));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Forgot password?",
                  style: TextStyle(color: kPrimaryColor),
                ),
                Text("   "),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
