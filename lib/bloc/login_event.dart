part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LogoutEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginRequestEvent extends LoginEvent {
  String username;
  String password;

  LoginRequestEvent(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}
