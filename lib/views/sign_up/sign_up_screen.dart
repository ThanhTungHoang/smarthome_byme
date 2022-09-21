import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smarthome_byme/BLoC/auth_bloc/auth_bloc.dart';
import 'package:smarthome_byme/core/constants.dart';
import 'package:smarthome_byme/core/router/routes.dart';
import 'package:smarthome_byme/models/signup/signup_model.dart';
import 'package:smarthome_byme/views/sign_in/components/already_have_an_account_acheck.dart';
import 'package:smarthome_byme/views/sign_in/components/textfield_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  @override
  void initState() {
    context.read<AuthBloc>().add(ResetState());
    super.initState();
  }

  @override
  void dispose() {
    fullname.dispose();
    email.dispose();
    password.dispose();
    rePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
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
                    Center(
                      child: TextButton(
                        child: const Text('Return to Sign In'),
                        onPressed: () {
                          GoRouter.of(context).pushNamed(RouteNames.signIn);
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
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
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Please enter the information to continue.",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            TextFieldAuth(
                              contronller: fullname,
                              defaultPadding: defaultPadding,
                              hintText: 'Full Name',
                              iconLeft: const Icon(Icons.person),
                              showIConHide: false,
                              kPrimaryColor: kPrimaryColor,
                              kPrimaryLightColor: kPrimaryLightColor,
                              nextAction: false,
                              obscureText: false,
                              typeEmail: false,
                              textValidator: "Full Name can't be too short",
                              lengthValidation: 5,
                            ),
                            const SizedBox(height: defaultPadding),
                            TextFieldAuth(
                              contronller: email,
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
                            if (state is ResponseEmail) ...[
                              Text(
                                "    ${state.alert}",
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.red),
                              ),
                            ],
                            const SizedBox(height: defaultPadding),
                            TextFieldAuth(
                                contronller: password,
                                nextAction: false,
                                obscureText: true,
                                kPrimaryColor: kPrimaryColor,
                                hintText: " Password",
                                defaultPadding: defaultPadding,
                                kPrimaryLightColor: kPrimaryLightColor,
                                iconLeft: const Icon(Icons.lock),
                                typeEmail: false,
                                textValidator: "Enter min. 6 characters",
                                showIConHide: true),
                            const SizedBox(height: defaultPadding),
                            TextFieldAuth(
                                contronller: rePassword,
                                nextAction: true,
                                obscureText: true,
                                kPrimaryColor: kPrimaryColor,
                                hintText: "Re enter password",
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
                            Hero(
                              tag: "register_btn",
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: kPrimaryColor,
                                  shape: const StadiumBorder(),
                                  maximumSize: const Size(double.infinity, 56),
                                  minimumSize: const Size(double.infinity, 56),
                                ),
                                onPressed: () async {
                                  _registerWithEmailAndPassword();
                                },
                                child: Text(
                                  "sign Up Now".toUpperCase(),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding),
                            AlreadyHaveAnAccountCheck(
                              login: false,
                              press: () {
                                GoRouter.of(context)
                                    .pushNamed(RouteNames.signIn);
                              },
                            ),
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
          );
        },
      ),
    );
  }

  void _registerWithEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
                SignUpParam(email: email.text, password: password.text),
                fullName: fullname.text,
                rePassword: rePassword.text),
          );
    }
  }
}
