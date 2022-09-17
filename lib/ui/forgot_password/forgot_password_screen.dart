import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome_byme/BLoC/auth_bloc/auth_bloc.dart';
import 'package:smarthome_byme/core/constants.dart';
import 'package:smarthome_byme/ui/sign_in/components/textfield_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKeyDialog = GlobalKey<FormState>();
  final _emailDialog = TextEditingController();
  @override
  void initState() {
    context.read<AuthBloc>().add(ResetState());
    super.initState();
  }

  @override
  void dispose() {
    _emailDialog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: SingleChildScrollView(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return ListBody(
              children: <Widget>[
                Form(
                  key: _formKeyDialog,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldAuth(
                        contronller: _emailDialog,
                        defaultPadding: defaultPadding,
                        hintText: 'Your email',
                        iconLeft: const Icon(Icons.email_outlined),
                        showIConHide: false,
                        kPrimaryColor: kPrimaryColor,
                        kPrimaryLightColor: kPrimaryLightColor,
                        nextAction: false,
                        obscureText: false,
                        typeEmail: true,
                        textValidator: 'Enter a valid email',
                      ),
                      const SizedBox(height: defaultPadding),
                      if (state is ResponseEmail) ...[
                        Center(
                          child: Text(
                            "    ${state.alert}",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.red),
                          ),
                        ),
                      ],
                      if (state is Loading) ...[
                        Center(
                          child: Column(
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: defaultPadding),
                            ],
                          ),
                        )
                      ],
                      if (state is AuthError) ...[
                        Center(
                          child: Column(
                            children: [
                              Text(
                                state.error,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.red),
                              ),
                              const SizedBox(height: defaultPadding),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Requested'),
          onPressed: () {
            _sendEmail();
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            context.read<AuthBloc>().add(ResetState());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _sendEmail() {
    if (_formKeyDialog.currentState!.validate()) {
      log("validation ok");
      context.read<AuthBloc>().add(SendEmailForgotPassword(_emailDialog.text));
    }
  }
}
