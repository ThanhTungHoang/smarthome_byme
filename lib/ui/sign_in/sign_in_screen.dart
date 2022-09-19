import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/BLoC/auth_bloc/auth_bloc.dart';
import 'package:smarthome_byme/core/constants.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/models/login/login_model.dart';
import 'components/already_have_an_account_acheck.dart';
import 'components/button_forgot_passsword.dart';
import 'components/textfield_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    context.read<AuthBloc>().add(CheckLogin());
    context.read<AuthBloc>().add(ResetState());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              GoRouter.of(context).goNamed(RouteNames.dashBoard);
            }
            if (state is DialogNotification) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Notification'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(state.notification),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Return'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 8,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "WELCOME!",
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Please sign in to continue.",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                TextFieldAuth(
                                  contronller: _email,
                                  defaultPadding: defaultPadding,
                                  hintText: 'Your email',
                                  iconLeft: const Icon(Icons.email_outlined),
                                  showIConHide: false,
                                  kPrimaryColor: kPrimaryColor,
                                  kPrimaryLightColor: kPrimaryLightColor,
                                  nextAction: true,
                                  obscureText: false,
                                  typeEmail: true,
                                  textValidator: 'Enter a valid email',
                                ),
                                if (state is ResponseEmail) ...[
                                  Text(
                                    "    ${state.alert}",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.red),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                const ForgotPassword(),
                                TextFieldAuth(
                                    contronller: _password,
                                    nextAction: true,
                                    obscureText: true,
                                    kPrimaryColor: kPrimaryColor,
                                    hintText: "Your password",
                                    defaultPadding: defaultPadding,
                                    kPrimaryLightColor: kPrimaryLightColor,
                                    iconLeft: const Icon(Icons.lock),
                                    typeEmail: false,
                                    textValidator: "Enter min. 6 characters",
                                    showIConHide: true),
                                if (state is ResponsePassword) ...[
                                  Text(
                                    "    ${state.alert}",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.red),
                                  ),
                                ],
                                const SizedBox(height: defaultPadding),
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
                                Hero(
                                  tag: "login_btn",
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: kPrimaryColor,
                                      shape: const StadiumBorder(),
                                      maximumSize:
                                          const Size(double.infinity, 56),
                                      minimumSize:
                                          const Size(double.infinity, 56),
                                    ),
                                    onPressed: () {
                                      _loginWithEmailAndPassword();
                                    },
                                    child: Text(
                                      "Login".toUpperCase(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: defaultPadding),
                                AlreadyHaveAnAccountCheck(
                                  press: () {
                                    GoRouter.of(context)
                                        .pushNamed(RouteNames.signUp);
                                  },
                                ),
                                // Center(
                                //   child: TextButton(
                                //     onPressed: () {},
                                //     child: const Text(
                                //       "Are you admin? click me.",
                                //       style: TextStyle(color: kPrimaryColor),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),

                    // const Spacer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _loginWithEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      log("validation ok");
      context.read<AuthBloc>().add(
            SignInRequested(
              LoginParam(
                email: _email.text,
                password: _password.text,
              ),
            ),
          );
    }
  }
}
