part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetState extends AuthEvent {}

class CheckLogin extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final LoginParam loginParam;

  SignInRequested(this.loginParam);
}

class SignUpRequested extends AuthEvent {
  final String fullName;
  final String rePassword;
  final SignUpParam signUpParam;

  SignUpRequested(this.signUpParam,
      {required this.fullName, required this.rePassword});
}

class SendEmailForgotPassword extends AuthEvent {
  final String email;

  SendEmailForgotPassword(this.email);
}

class SignOutRequested extends AuthEvent {}
