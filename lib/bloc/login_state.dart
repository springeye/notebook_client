part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class AuthErrorState extends LoginState {
  String error;
  String username;
  String password;

  AuthErrorState(this.error, this.username, this.password);

  @override
  List<Object?> get props => [error, username, password];
}

class AuthenticatedState extends LoginState {
  AuthenticatedState() : super();

  @override
  List<Object?> get props => [];
}

class UnauthenticatedState extends LoginState {
  @override
  List<Object?> get props => [];
}
