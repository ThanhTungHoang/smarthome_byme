part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class Loading extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class ResponseEmail extends AuthState {
  final String alert;

  ResponseEmail(this.alert);
  @override
  List<Object?> get props => [alert];
}

class ResponsePassword extends AuthState {
  final String alert;

  ResponsePassword(this.alert);
  @override
  List<Object?> get props => [alert];
}

class DialogNotification extends AuthState {
  final String notification;

  DialogNotification(this.notification);
  @override
  List<Object?> get props => [notification];
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
  @override
  List<Object?> get props => [error];
}
